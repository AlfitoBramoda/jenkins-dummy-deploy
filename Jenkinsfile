pipeline {
    agent any

    parameters {
        string(name: 'URL_REPO', defaultValue: 'https://github.com/AlfitoBramoda/jenkins-dummy-deploy.git', description: 'GitHub Repository URL')
        string(name: 'GIT_BRANCH', defaultValue: 'main', description: 'Branch repository')
        choice(name: 'ENV', choices: ['DEV', 'STAGING'], description: 'Environment untuk deploy')
    }

    options {
        skipDefaultCheckout(true)
    }

    stages {
        stage('Checkout Repository') {
            steps {
                checkout([$class: 'GitSCM',
                    branches: [[name: "*/${params.GIT_BRANCH}"]],
                    userRemoteConfigs: [[ url: "${params.URL_REPO}" ]]
                ])
            }
        }

        stage('Show Parameters') {
            steps {
                echo "Repo: ${params.URL_REPO}"
                echo "Branch: ${params.GIT_BRANCH}"
                echo "Environment: ${params.ENV}"
            }
        }

        stage('Prepare Payload') {
            steps {
                script {
                    def original = readJSON file: "scripts/promotion_payload.json"
                    original.destinationStages = [params.ENV]
                    def payloadString = groovy.json.JsonOutput.toJson(original)

                    writeFile file: 'payload_temp.json', text: payloadString
                    echo "📝 Final Payload: ${payloadString}"
                }
            }
        }

        stage('Execute Deploy Script') {
            steps {
                withCredentials([usernamePassword(credentialsId: '13a1f1f4-d5b6-4ad0-a1ba-175e0cc888d1', usernameVariable: 'USER', passwordVariable: 'PASSWORD')]) {
                    script {
                        def FINAL_URL = "https://httpbin.org/post"
                        def authString = "${USERNAME}:${PASSWORD}"
                        def encoded = Base64.encoder.encodeToString(authString.getBytes("UTF-8"))
                        env.AUTH = encoded

                        // langsung pakai bash, tidak perlu chmod
                        sh """bash scripts/deploy.sh "$AUTH" "$FINAL_URL" "payload_temp.json" """
                    }
                }
            }
        }
    }
}
