pipeline {
    agent {
        label 'wpagent'
    }   
    stages {
        stage("Run"){
            steps {
                echo "=======Start Jenkinsfile======="
                sh "make run"
            }
            post {
                success {
                    echo "========A executed successfully========"
                }
                failure {
                    echo "========A execution failed========"
                }
            }
        }
    }
    post {
        success {
            echo "========pipeline executed successfully========"
        }
        failure {
            echo "========pipeline execution failed========"
        }
    }
}