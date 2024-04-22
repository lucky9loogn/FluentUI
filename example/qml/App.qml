import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

FluLauncher {
    id: app
    Connections{
        target: FluTheme
        function onDarkModeChanged(){
            SettingsHelper.saveDarkMode(FluTheme.darkMode)
        }
    }
    Connections{
        target: FluApp
        function onUseSystemAppBarChanged(){
            SettingsHelper.saveUseSystemAppBar(FluApp.useSystemAppBar)
        }
    }
    Connections{
        target: TranslateHelper
        function onCurrentChanged(){
            SettingsHelper.saveLanguage(TranslateHelper.current)
        }
    }
    Component.onCompleted: {
        Network.openLog = false
        Network.setInterceptor(function(param){
            param.addHeader("Token","000000000000000000000")
        })
        FluApp.init(app,Qt.locale(TranslateHelper.current))
        FluApp.windowIcon = "qrc:/example/res/image/favicon.ico"
        FluApp.useSystemAppBar = SettingsHelper.getUseSystemAppBar()
        FluTheme.darkMode = SettingsHelper.getDarkMode()
        FluTheme.animationEnabled = true
        FluTheme.blurBehindWindowEnabled = true
        FluRouter.routes = {
            "/":"qrc:/example/qml/window/MainWindow.qml",
            "/about":"qrc:/example/qml/window/AboutWindow.qml",
            "/login":"qrc:/example/qml/window/LoginWindow.qml",
            "/hotload":"qrc:/example/qml/window/HotloadWindow.qml",
            "/crash":"qrc:/example/qml/window/CrashWindow.qml",
            "/singleTaskWindow":"qrc:/example/qml/window/SingleTaskWindow.qml",
            "/standardWindow":"qrc:/example/qml/window/StandardWindow.qml",
            "/singleInstanceWindow":"qrc:/example/qml/window/SingleInstanceWindow.qml",
            "/pageWindow":"qrc:/example/qml/window/PageWindow.qml"
        }
        var args = Qt.application.arguments
        if(args.length>=2 && args[1].startsWith("-crashed=")){
            FluRouter.navigate("/crash",{crashFilePath:args[1].replace("-crashed=","")})
        }else{
            FluRouter.navigate("/")
        }
    }
}
