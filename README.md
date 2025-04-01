# 安全WiFi：WPA3和WPA2企业版与EAP-TLS
WiFi几乎无处不在，适当的安全措施非常重要。相比基于密码的解决方案，WPA3和WPA2企业版（以下简称：WPA2企业版）是一种用户友好且安全的替代方案。WPA2企业版中的一个选项是EAP-TLS。这种认证协议使用X.509证书确保用户连接到真实的WiFi网络。客户端证书向WiFi网络保证客户端的真实性。本仓库提供了一些脚本来创建和管理EAP-TLS设置的关键组件：RADIUS服务器和用于管理证书颁发机构(CA)及X.509证书的公钥基础设施(PKI)。RADIUS服务器使用FreeRadius开源项目。通过使用几个包装脚本，简化了FreeRadius的配置复杂性。RADIUS服务器使用Docker和docker-compose运行。

完整设置包含以下元素：
- WiFi客户端，例如连接到WiFi网络的Windows 11笔记本电脑
- 支持RADIUS认证的WiFi接入点。本设置已在Ubiquity UniFi接入点和UniFi Network Controller软件上测试通过（本项目与Ubiquiti没有任何关系）。
- 在安装了docker-compose的Docker服务器上运行的RADIUS服务器和PKI（本项目）。常规WPA3企业版已成功测试（并使用）。使用WPA3企业版提供的192位安全模式所需的更改尚待确定。欢迎对此主题提供意见。

# 入门指南
- 首先使用WPA2预共享密钥建立一个正常运行的WiFi网络
- 将此仓库克隆到安装了docker-compose的Docker服务器上
- 在此仓库的主目录中以root身份（或使用sudo）执行以下命令。
- 运行`./scripts/setup_config.sh`创建一些目录并创建`.env`文件。
- 编辑主目录中的`.env`文件。必要的调整在该文件的注释中有说明。
- 执行`docker-compose build`，然后执行`docker-compose up`（这可能需要一些时间）。
- 等待初始化完成。使用`Ctrl+c`结束，然后使用`docker-compose up -d`重新启动
- 运行`./scripts/cli_management.sh`。这将在包含一些管理脚本的目录中提供root shell。
- 运行`./manageclients.sh`获取注册Radius客户端的帮助。Radius客户端例如是WiFi接入点。
- 注册您的Radius客户端。不要忘记记下密码。
- 创建WPA2企业版WiFi网络，并在网络控制器软件中通过IP注册Radius服务器。如果需要，启用Radius服务器提供的VLAN使用。
- 使用exit（或Ctrl+d）关闭shell。radius服务将重新启动。

# 使用EAP-TLS添加您的第一个设备
- 在此仓库的主目录中以root身份（或使用sudo）执行以下命令。
- 运行`./scripts/cli_management.sh`。这将在包含一些管理脚本的目录中提供root shell。
- 运行`./manageusers.sh`获取为您的设备创建密钥/证书对的帮助。
- 生成密钥/证书对。记下密码并关闭shell。
- 在provision目录中，您可以找到证书颁发机构证书(ca.der)和密码保护的密钥/证书文件(*.p12)。使用USB存储设备或例如`scp`将这些文件复制到您的设备。在实验环境中，可以在provision目录中使用`python3 -m http.server 8000`之类的命令使文件可用。
- 使用这些文件配置带有EAP-TLS认证的WiFi。参见例如[Windows说明](docs/windows.md)、[Android说明](docs/android.md)、[Linux说明](docs/linux.md)或[iOS说明](docs/ios.md)