import os
import subprocess
import time

class ParticleBase:
    def update_pubspec_dependency(self, version):
        # Read the original pubspec.yaml file content
        with open('pubspec.yaml', 'r') as file:
            lines = file.readlines()

        # Find the particle_auth dependency and update the version number
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

        # Write the updated content back to the file
        with open('pubspec.yaml', 'w') as file:
            file.writelines(updated_lines)

    def __init__(self, version):
        self.version = version
        self.pubspec_path = 'pubspec.yaml'
        self.changelog_path = 'CHANGELOG.md'

    def replace_version(self):
        with open(self.pubspec_path, 'r') as file:
            lines = file.readlines()

        # Modify the third line
        lines[2] = f'version: {self.version}\n'

        with open(self.pubspec_path, 'w') as file:
            file.writelines(lines)

    def add_to_changelog(self):
        with open(self.changelog_path, 'r') as file:
            lines = file.readlines()

        # Check if the first line contains the new version number
        if f'## {self.version}\n' not in lines:
            # Add new version information to the first line
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

    def publish_dry_run(self):
        self.prepare()
        self.flutter_publish_dry_run()
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


if __name__ == "__main__":
    version = '2.1.22'
    sleep_time = 60
    print("Base Start")
    ParticleAuth(version).publish()
    print("Base Finish")
    time.sleep(sleep_time)
    print("AuthCore Start")
    ParticleAuthCore(version).publish()
    print("AuthCore Finish")
    time.sleep(sleep_time)
    print("Connect Start")
    ParticleConnect(version).publish()
    print("Connect Finish")
    time.sleep(sleep_time)

    print("ParticleAA Start")
    ParticleAA(version).publish()
    print("ParticleAA Finish")
    time.sleep(sleep_time)
    print("ParticleWallet Start")
    ParticleWallet(version).publish()
    print("ParticleWallet Finish")
