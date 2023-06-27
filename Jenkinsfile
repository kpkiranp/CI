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
            steps{
                   sh "chmod +x changetag.sh"
                   sh "./changetag.sh ${DOCKER_TAG}"
						sh '''
                            pwd
                            cd
                            pwd 
                            git clone https://github.com/kpkiranp/CD.git
                            cp -r CI/manifests ~/CD
                            cd CD
                            git add .
                            git commit -m "manifests updated with ${DOCKER_TAG}" 
                            git push origin
                        '''
					}
				}
            }
        }


def getDockerTag(){
    def tag  = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}