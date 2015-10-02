from fabric.api import local, run, env, cd
from datetime import datetime

def live():
    env.user = 'root'
    env.hosts = ['feelicity.es']

def deploy():
    now = datetime.now()
    current_version_name = now.strftime("%Y%m%d%H%M%S")

    print("===== Deploying ... =====\n")
    
    print("== Stoping feelicity app ==")
    run("/etc/init.d/feelicity stop")

    print("== Downloading new version from repository  ==")
    #with cd("/var/www/feelicity"):
    #    run("svn export http://desarrollo.ibercivis.es/streetrs/trunk/tedx " + current_version_name)
    with cd("$HOME/feelicity-web"):
        run("hg pull")
        run("hg update")
        run("hg archive /var/www/feelicity/" + current_version_name)

    print("== Changing current version to this one ")
    run("rm /var/www/feelicity/current")
    run("ln -s /var/www/feelicity/" + current_version_name + " /var/www/feelicity/current")

    print("== Making symbolic link to user data files and avatars ==")
    run("ln -s /var/www/feelicity/user_data /var/www/feelicity/current/tedx/public/files")
    run("ln -s /var/www/feelicity/avatars /var/www/feelicity/current/tedx/public/avatars")

    print("== Change ownersip of the app directory ==")
    run("chown -R www-data:www-data /var/www/feelicity/" + current_version_name)

    print("== Executing SQL scripts ==")
    with cd("/var/www/feelicity/current"):
        run("mysql --user=tedx --password=tedx < db/last_changes.sql")

    print("== Starting feelicity app")
    run("/etc/init.d/feelicity start")

    print("\n===== Deploy ended =====")
