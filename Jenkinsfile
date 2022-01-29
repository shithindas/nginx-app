pipeline {
  agent any
  environment { 
      ENV='dev'
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
            branches: [[name: '*/master']], 
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
                docker.build("shithindas/nginx")
            }
            }
            script {
                docker.withRegistry("https://registry.hub.docker.com", "dockerhub_user") {
                docker.image("shithindas/nginx").push(IMAGE_VERSION)
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
            kubectl create cm nginx-config-${IMAGE_VERSION} --from-file=nginx-config
            """
        }     
    }       
  } 
}