import os
import requests
import subprocess
import time

class ParticleBase:
    def update_pubspec_dependency(self, version):
        with open('pubspec.yaml', 'r') as file:
            lines = file.readlines()

        updated_lines = []
        for line in lines:
            if line.strip().startswith('#'):
                updated_lines.append(line)
            elif line.strip().startswith('particle_base:'):
                updated_lines.append(f'  particle_base: ^{version}\n')
            elif line.strip().startswith('particle_connect:'):
                updated_lines.append(f'  particle_connect: ^{version}\n')
            elif line.strip().startswith('particle_auth_core:'):
                updated_lines.append(f'  particle_auth_core: ^{version}\n')
            else:
                updated_lines.append(line)

        with open('pubspec.yaml', 'w') as file:
            file.writelines(updated_lines)

    def __init__(self, version):
        self.version = version
        self.pubspec_path = 'pubspec.yaml'
        self.changelog_path = 'CHANGELOG.md'

    def replace_version(self):
        with open(self.pubspec_path, 'r') as file:
            lines = file.readlines()

        lines[2] = f'version: {self.version}\n'

        with open(self.pubspec_path, 'w') as file:
            file.writelines(lines)

    def add_to_changelog(self):
        with open(self.changelog_path, 'r') as file:
            lines = file.readlines()

        if f'## {self.version}\n' not in lines:
            lines.insert(0, f'## {self.version}\n\n')

            with open(self.changelog_path, 'w') as file:
                file.writelines(lines)
        else:
            print(f'Version {self.version} already exists in CHANGELOG.md')

    def flutter_publish_dry_run(self):
        subprocess.run(['flutter', 'pub', 'publish', '--dry-run'])

    def flutter_publish(self):
        subprocess.run(['flutter', 'pub', 'publish'])

    def flutter_get(self):
        subprocess.run(['flutter', 'pub', 'get'])

    def close(self):
        os.chdir("..")

    def prepare(self):
        self.replace_version()
        self.add_to_changelog()


class ParticleAuth(ParticleBase):
    def __init__(self, version):
        os.chdir("particle-base")
        super().__init__(version)

    def publish(self):
        self.prepare()
        self.flutter_publish()
        self.close()


class ParticleConnect(ParticleBase):
    def __init__(self, version):
        os.chdir("particle-connect")
        super().__init__(version)

    def self_prepare(self):
        self.update_pubspec_dependency(self.version)

    def publish(self):
        self.prepare()
        self.self_prepare()
        self.flutter_get()
        self.flutter_publish()
        self.close()


class ParticleAuthCore(ParticleBase):
    def __init__(self, version):
        os.chdir("particle-auth-core")
        super().__init__(version)

    def self_prepare(self):
        self.update_pubspec_dependency(self.version)

    def publish(self):
        self.prepare()
        self.self_prepare()
        self.flutter_get()
        self.flutter_publish()
        self.close()


class ParticleAA(ParticleBase):
    def __init__(self, version):
        os.chdir("particle-aa")
        super().__init__(version)

    def self_prepare(self):
        self.update_pubspec_dependency(self.version)
        os.chdir("example")
        self.update_pubspec_dependency(self.version)
        os.chdir("..")

    def publish(self):
        self.prepare()
        self.self_prepare()
        self.flutter_get()
        self.flutter_publish()
        self.close()


class ParticleWallet(ParticleBase):
    def __init__(self, version):
        os.chdir("particle-wallet")
        super().__init__(version)

    def self_prepare(self):
        self.update_pubspec_dependency(self.version)

    def publish(self):
        self.prepare()
        self.self_prepare()
        self.flutter_get()
        self.flutter_publish()
        self.close()


def is_package_published(package_name, version):
    """
    Check if a package version is published on pub.dev.
    """
    try:
        url = f"https://pub.dev/api/packages/{package_name}"
        response = requests.get(url)
        response.raise_for_status()

        package_data = response.json()
        latest = package_data.get('latest', {})
        latest_version = latest.get('version')
        print('latest_version:',latest_version)
        if latest_version == version:
            print(f"✅ {package_name} version {version} is published!")
            return True
        else:
            print(f"❌ {package_name} version {version} is not published yet.")
            return False
    except requests.RequestException as e:
        print(f"Error checking package publication: {e}")
        return False


def wait_until_published(package_name, version):
    """
    Wait until the package version is published.
    """
    while not is_package_published(package_name, version):
        print(f"Waiting for {package_name} version {version} to be published...")
        time.sleep(10)  # Wait 10 seconds before checking again


if __name__ == "__main__":
    version = '2.1.23'

    print("Base Start")
    ParticleAuth(version).publish()
    wait_until_published("particle_base", version)
    print("Base Finish")

    print("AuthCore Start")
    ParticleAuthCore(version).publish()
    wait_until_published("particle_auth_core", version)
    print("AuthCore Finish")

    print("Connect Start")
    ParticleConnect(version).publish()
    wait_until_published("particle_connect", version)
    print("Connect Finish")

    print("ParticleAA Start")
    ParticleAA(version).publish()
    wait_until_published("particle_aa", version)
    print("ParticleAA Finish")

    print("ParticleWallet Start")
    ParticleWallet(version).publish()
    wait_until_published("particle_wallet", version)
    print("ParticleWallet Finish")
