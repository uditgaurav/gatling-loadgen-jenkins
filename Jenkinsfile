pipeline {
  agent {
    kubernetes {
      label 'chaos-gatling-agent'
      defaultContainer 'jnlp'
    }
  }

  environment {
    HOST = "${params.HOST}"
    NUM_USERS = "${params.NUM_USERS}"
    TEST_DURATION = "${params.TEST_DURATION}"
    NAMESPACE = "${params.NAMESPACE}"

    ACCOUNT_ID = "${params.ACCOUNT_ID}"
    ORG_ID = "${params.ORG_ID}"
    PROJECT_ID = "${params.PROJECT_ID}"
    WORKFLOW_ID = "${params.WORKFLOW_ID}"
    EXPECTED_RESILIENCE_SCORE = "${params.EXPECTED_RESILIENCE_SCORE}"
    DELAY = "${params.DELAY}"
    TIMEOUT = "${params.TIMEOUT}"
  }

  parameters {
    string(name: 'HOST', defaultValue: 'http://af4d44ba720bf49a48d12c7012a9ed1c-1731688269.us-west-2.elb.amazonaws.com', description: 'Base URL')
    string(name: 'NUM_USERS', defaultValue: '300', description: 'No. of users')
    string(name: 'TEST_DURATION', defaultValue: '60', description: 'Test duration in seconds')
    string(name: 'NAMESPACE', defaultValue: 'default', description: 'K8s namespace')

    string(name: 'ACCOUNT_ID', defaultValue: 'cTU1lRSWS2SSRV9phKvuOA', description: 'Harness Account ID')
    string(name: 'ORG_ID', defaultValue: 'default', description: 'Harness Org ID')
    string(name: 'PROJECT_ID', defaultValue: 'chaostestingprod', description: 'Harness Project ID')
    string(name: 'WORKFLOW_ID', defaultValue: '428b95a8-3978-4e05-9ea4-c54d40c5bc68', description: 'Chaos Workflow ID')
    string(name: 'EXPECTED_RESILIENCE_SCORE', defaultValue: '50', description: 'Minimum expected resilience score')

    string(name: 'DELAY', defaultValue: '2', description: 'Monitoring delay in seconds')
    string(name: 'TIMEOUT', defaultValue: '500', description: 'Monitoring timeout in seconds')
  }

  stages {
    stage('Prepare ConfigMaps') {
      steps {
        sh 'scripts/prepare-configmaps.sh'
      }
    }

    stage('Deploy Gatling Pod') {
      steps {
        sh 'scripts/deploy-loadgen.sh'
      }
    }

    stage('Run Load and Chaos in Parallel') {
      parallel {
        stage('Run Gatling LoadGen') {
          steps {
            sh 'scripts/run-loadgen.sh'
          }
        }

        stage('Run Chaos Experiment & Validate') {
          steps {
            withCredentials([string(credentialsId: 'API_KEY', variable: 'API_KEY')]) {
              sh '''
                ACCOUNT_ID="${ACCOUNT_ID}" \
                ORG_ID="${ORG_ID}" \
                PROJECT_ID="${PROJECT_ID}" \
                WORKFLOW_ID="${WORKFLOW_ID}" \
                API_KEY="${API_KEY}" \
                EXPECTED_RESILIENCE_SCORE="${EXPECTED_RESILIENCE_SCORE}" \
                DELAY="${DELAY}" \
                TIMEOUT="${TIMEOUT}" \
                bash scripts/run-chaos.sh
              '''
            }
          }
        }
      }
    }

    stage('Cleanup') {
      steps {
        sh 'scripts/cleanup.sh'
      }
    }
  }

  post {
    always {
      echo "Pipeline execution complete."
    }
  }
}

