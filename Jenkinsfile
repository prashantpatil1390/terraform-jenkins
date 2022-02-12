pipeline {
  agent any
  environment {
    PATH = "${PATH}:${getTerraformPath()}"
  }

  stages{
    stage('S3- Create Backent Bucket'){
      steps{
        script{
          createBackendS3Bucket('terraform-state-prash')
        }
      }
    }
    stage('Terraform init and apply') {
      steps{
#        sh returnStatus:true, script: 'terraform workspace new dev'
        sh "terraform init"
        sh "terraform apply -auto-approve"
#        sh "terraform apply -var-file=dev.tfvars -auto-approve"
      }
    }

  }
}

def getTerraformPath(){
  def tfHome = tool name: 'Terraform-1.1.5', type: 'terraform'
  return tfHome
}

def createBackendS3Bucket(bucketName) {
  sh refutrnStatus:true, script: "aws s3 mb ${bucketName} --region=us-east-1"
