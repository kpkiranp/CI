pipeline{
    agent any
    environment{
        DOCKER_TAG = getDockerTag()
    }
    stages{
        stage('GetSourceCode') {
            steps{
                git branch: 'main', url: 'https://github.com/kpkiranp/CI.git'
            }
        }
        stage('BuildDockerImage') {
            steps{
                withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'dockerPwd', usernameVariable: 'dockerUsr')]) {
                    sh '''
                        docker build . -t ${dockerUsr}/tomcat:${DOCKER_TAG} 
                        docker login -u ${dockerUsr} -p ${dockerPwd}
                        docker push ${dockerUsr}/tomcat:${DOCKER_TAG}
                    '''
                }
            }
        }
        stage('PushManifestsToCDRepository'){
            environment {
                GIT_REPO_NAME = "CD"
                GIT_USER_NAME = "kpkiranp"
        }
            steps{
                
                withCredentials([string(credentialsId: 'sshgithub', keyFileVariable: 'key', usernameVariable: 'gitusr')]) {
                   sh "chmod +x changetag.sh"
                   sh "./changetag.sh ${DOCKER_TAG}"
						sh '''
                            pwd
                            cd
                            pwd 
                            if [ -d /var/lib/jenkins/CD ];
                            then
                            cd /var/lib/jenkins/CD
                            git pull
                            else
                            git clone https://github.com/kpkiranp/CD.git 
                            fi                          
                            cp -r /var/lib/jenkins/workspace/HPA_task/manifests /var/lib/jenkins/CD
                            git add .
                            git commit -m "manifests updated with ${DOCKER_TAG}" 
                            git push 
                        '''
					}
				}
            }
        }
}


def getDockerTag(){
    def tag  = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}
