pipeline {
  agent any
  environment { 
      ENV='dev'
      DEP_NAME='node-web'
  }
  options { disableConcurrentBuilds() }
  stages {
    stage('Clean Workspace') {
      steps {
        cleanWs()
      }
    }
    stage('Clone Repositories') {
      steps {
        dir('nginx-app') {
            checkout([$class: 'GitSCM', 
            branches: [[name: 'node']], 
            extensions: [], 
            userRemoteConfigs: [[
                credentialsId: 'github_user',
                url: 'git@github.com:shithindas/nginx-app.git']]
            ])
        }
      }
    }
    // stage('Login to Docker Repo') {
    //   steps{
    //     sh '$(aws ecr get-login --no-include-email --region us-east-1) '
    //   }
    // }
    stage('Build Preparations'){
      steps{
         script {
            VERSION = env.BUILD_NUMBER
            IMAGE_VERSION = "$ENV-$VERSION"
         } 
      }
    } 
    stage('Build Nginx APP') {
        steps {
            dir ("nginx-app") {
            script {
                docker.build("shithindas/nginx-app")
            }
            }
            script {
                docker.withRegistry("https://registry.hub.docker.com", "dockerhub_user") {
                docker.image("shithindas/nginx-app").push(IMAGE_VERSION)
                }
            }
        }       
    }
    stage('Copy Kube') {
        environment {
              KUBE_FILE=credentials('kubeconfig')
        }
        steps {
            sh """
            cp -vf ${KUBE_FILE} $WORKSPACE/nginx-app/Manifests
            """
        }     
    }
    stage('Create ConfigMap') {
        steps {
            sh """
            cd $WORKSPACE/nginx-app/Manifests
            export KUBECONFIG=admin.conf
            kubectl create cm nginx-config-${IMAGE_VERSION} --from-file=default.conf
            """
        }     
    }
    stage('Deploy MySQL') {
        steps {
            sh """
            cd $WORKSPACE/nginx-app/Manifests
            export KUBECONFIG=admin.conf
            #Creating MySQL Persistant Volume on Disk
            kubectl apply -f mysql-pv.yaml
            #Deploying MySQL
            kubectl apply -f mysql-deployment.yaml
            """
        }     
    }
    stage('Deploy_K8S') {
        steps {
            sh """
            cd $WORKSPACE/nginx-app/Manifests
            export KUBECONFIG=admin.conf
            sed -i 's/BUILD_ID/${IMAGE_VERSION}/g' app-deployment.yaml
            kubectl apply -f app-deployment.yaml
            kubectl rollout status deployment ${DEP_NAME}
            """
        }     
    }       
  }
  post {
    always {
      echo "Removing Secrets"
      sh script: 'rm -fv $WORKSPACE/nginx-app/Manifests/admin.conf'
    }
  }  
}