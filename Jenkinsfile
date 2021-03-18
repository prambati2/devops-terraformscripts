def projectId = "mar-roidtc315"

pipeline {
   agent any

   stages {
        stage('Stage 1 - workspace and versions') {
            steps {
                sh 'echo $WORKSPACE'
                sh 'docker --version'
                sh 'gcloud version'
                sh 'nodejs -v'
                sh 'npm -v'
            }
        }
        stage('Stage 2 - build external') {
            // setting env variable so external default port does not conflict with jenkins
            environment {
                PORT = 8081
            }
            steps {
                dir("${env.WORKSPACE}/external"){
                    echo 'Retrieving source from github' 
                    git branch: 'master',
                        url: 'https://github.com/KevinRattan/terraform-jenkins-k8s-external.git'
                    echo 'Did we get the source?' 
                    sh 'ls -a'
                    echo 'install dependencies' 
                    sh 'npm install'
                    echo 'Run tests'
                    sh 'npm test'
                    echo 'Tests passed on to build Docker container'
                    echo "build id = ${env.BUILD_ID}"
                    sh "gcloud builds submit -t gcr.io/${projectId}/external:v20.${env.BUILD_ID} ."
                }
            }
        }
        stage('Stage 3 - build internal') {
            steps {
                dir("${env.WORKSPACE}/internal"){
                  echo 'Retrieving source from github' 
                    git branch: 'master',
                        url: 'https://github.com/KevinRattan/terraform-jenkins-k8s-internal.git'
                    sh "ls -a"
                    echo 'install dependencies' 
                    sh 'npm install'
                    echo 'Run tests'
                    sh 'npm test'
                    echo 'Tests passed on to build Docker container'
                    echo "build id = ${env.BUILD_ID}"
                    sh "gcloud builds submit -t gcr.io/${projectId}/internal:v20.${env.BUILD_ID} ."
                }
            }
        }
        stage('Stage 4 - deploy using terraform') {
            steps {
                dir("${env.WORKSPACE}/terraform"){
                  echo 'Retrieving source from github' 
                    git branch: 'master',
                        url: 'https://github.com/KevinRattan/terraform-jenkins-k8s-terraform.git'
                    sh "ls -a"  
                    sh 'terraform init'
                     sh "terraform apply -var project_id=${projectId} -var external_image_name=external:v20.${env.BUILD_ID}  -var internal_image_name=internal:v20.${env.BUILD_ID}  -auto-approve"
                  }
            }
            
        }
   }
}