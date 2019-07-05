pipeline {
	agent any
	options {
		timestamps()
	}
	environment {
		TimeStamp="${currentBuild.startTimeInMillis}"
		Service="${JOB_BASE_NAME}"
		Branch="${env.gitlabTargetBranch}"
	}
	parameters {
		choice(name: 'Action',choices: '程序发版\n程序回滚',description: '请选择操作')
		choice(name: 'Scope',choices: '测试环境\n预发环境\n生产环境\n灾备环境',description: '请选择部署环境')
		string(name: 'JenkinsApi', defaultValue: 'false', description: '是否是JenkinsAPI触发,默认请不要填写。')
		string(name: 'BranchOrTag', defaultValue: '', description: '指定分支或tag发版,默认请不要填写。')
	}
	stages {
		stage('PrintEnv') {
			steps {
				sh "printenv"
			}
		}
		stage('Check Out') {
			when {
				anyOf {
					environment name: 'Branch',value:'master';
					environment name: 'Branch',value:'test';
					environment name: 'Scope',value:'测试环境';
					environment name: 'Scope',value:'预发环境';
					environment name: 'Scope',value:'灾备环境'
				}
			}
			steps {
				sh "sh jenkins.sh 'CheckOut' '${Service}' '${Branch}' '${Scope}' '${TimeStamp}' '${BranchOrTag}'"
			}
		}
		stage('Build Package') {
			when {
				anyOf {
					environment name: 'Branch',value:'master';
					environment name: 'Branch',value:'test';
					environment name: 'Scope',value:'测试环境';
					environment name: 'Scope',value:'预发环境';
					environment name: 'Scope',value:'灾备环境'
				}
			}
			steps {
				sh "sh jenkins.sh 'BuildPackage' '${Service}' '${Branch}' '${Scope}' '${TimeStamp}'"
			}
		}
		stage('Build Dockerfile') {
			when {
				anyOf {
					environment name: 'Branch',value:'master';
					environment name: 'Branch',value:'test';
					environment name: 'Scope',value:'测试环境';
					environment name: 'Scope',value:'预发环境';
					environment name: 'Scope',value:'生产环境';
					environment name: 'Scope',value:'灾备环境'
				}
			}
			steps {
				sh "sh jenkins.sh 'BuildDockerfile' '${Service}' '${Branch}' '${Scope}' '${TimeStamp}'"
			}
		}
		stage('Build K8S Yaml') {
			when {
				anyOf {
					environment name: 'Branch',value:'master';
					environment name: 'Branch',value:'test';
					environment name: 'Scope',value:'测试环境';
					environment name: 'Scope',value:'预发环境';
					environment name: 'Scope',value:'生产环境';
					environment name: 'Scope',value:'灾备环境'
				}
			}
			steps {
				sh "sh jenkins.sh 'BuildK8SYaml' '${Service}' '${Branch}' '${Scope}' '${TimeStamp}' '${env.Action}'"
			}
		}
		stage('Deploy') {
			steps {
				script {
					if ("${Scope}" == "测试环境") {
						echo "测试环境发版"
						sh "sh jenkins.sh 'DockerBuildPush' '${Service}' '${Branch}' '${Scope}' '${TimeStamp}' '${env.Action}'"
						sh "sh jenkins.sh 'Deploy' '${Service}' '${Branch}' '${Scope}' '${TimeStamp}'"
					}
					if ("${Scope}" == "预发环境") {
						echo "预发环境发版"
						sh "sh jenkins.sh 'DockerBuildPush' '${Service}' '${Branch}' '${Scope}' '${TimeStamp}' '${env.Action}'"
						sh "sh jenkins.sh 'Deploy' '${Service}' '${Branch}' '${Scope}' '${TimeStamp}'"
					}
					if ("${Scope}" == "灾备环境") {
						echo "灾备环境发版"
						sh "sh jenkins.sh 'DockerBuildPush' '${Service}' '${Branch}' '${Scope}' '${TimeStamp}' '${env.Action}'"
						sh "sh jenkins.sh 'Deploy' '${Service}' '${Branch}' '${Scope}' '${TimeStamp}'"
					}
					if ("${Scope}" == "生产环境") {
						script {
							if ("${JenkinsApi}" == "true") {
								sh "sh jenkins.sh 'DockerBuildPush' '${Service}' '${Branch}' '${Scope}' '${TimeStamp}' '${env.Action}'"
								sh "sh jenkins.sh 'Deploy' '${Service}' '${Branch}' '${Scope}' '${TimeStamp}'"
							}
							else {
								script {
									if ("${env.Action}" == "程序回滚") {
										echo "生产环境回滚,等待领导确认"
										script {
											input message: "请确认是否回滚 ${Scope}： ",ok : '确认',submitter: "admin"
										}
										echo '已确认，即将回滚'
										sh "sh jenkins.sh 'Deploy' '${Service}' '${Branch}' '${Scope}' '${TimeStamp}' '${env.Action}'"
									}
									else {
										echo "生产环境发版,等待领导确认"
										script {
											input message: "请确认是否部署 ${Scope}： ",ok : '确认',submitter: "admin"
										}
										echo '已确认，即将发布'
										sh "sh jenkins.sh 'DockerBuildPush' '${Service}' '${Branch}' '${Scope}' '${TimeStamp}' '${env.Action}'"
										sh "sh jenkins.sh 'Deploy' '${Service}' '${Branch}' '${Scope}' '${TimeStamp}'"
									}
								}
							}
						}
					}
				}
			}
		}
	}
}
