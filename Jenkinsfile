pipeline {
  agent any
  environment {
    PATH = "${PATH}:${getTerraformPath()}"
  }

  stages{
    stage('Terraform init and apply') {
      steps{
        sh "terraform init"
        sh "terraform apply -auto-approve"
      }
    }

  }
}

def getTerraformPath(){
  def tfHome = tool name: 'Terraform-1.1.5', type: 'terraform'
  return tfHome
}

