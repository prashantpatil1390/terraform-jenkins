pipeline {
  agent any
  environment {
    PATH = "${PATH}:${getTerraformPath()}"
  }

  stages{
    stage('Terraform init') {
      steps{
        sh "terraform init"
      }
    }
  }
}

def getTerraformPath(){
  def tfHome = tool name: 'Terraform-1.1.5', type: 'terraform'
  return tfHome
}

