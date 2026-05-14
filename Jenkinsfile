pipeline {
    agent any

    stages {

        stage('Clone Check') {
            steps {
                echo "Repository pulled successfully"
            }
        }

        stage('List Notes') {
            steps {
                sh 'find . -name "*.md"'
            }
        }

        stage('Count Notes') {
            steps {
                sh 'find . -name "*.md" | wc -l'
            }
        }

        stage('Backup') {
            steps {
                sh 'zip -r notes_backup.zip .'
            }
        }
    }
}
