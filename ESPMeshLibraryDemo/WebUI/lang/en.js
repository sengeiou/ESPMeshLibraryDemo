define(function(){
    var m = {
        "email":"Email address",
        "password":"Password",
        "login":"Log in",
        "forgot": "Forgot the password",
        "register": "Register",
        "guest": "Guest mode",
        "userName": "User name",
        "inputPwd": "Enter the password",
        "confirmPwd": "Confirmm the password",
        "confirmBtn": "Confirm",
        "editBtn": "Edit",
        "cancelBtn": "Cancel",
        "deleteBtn": "Delete",
        "upgradeBtn": "Upgrade",
        "tryAgainBtn": "Try again",
        "retryBtn": "Retry",
        "joinBtn": "Add the device to the mesh network",
        "selectJoinBtn": "Select device to add to mesh network",
        "loading": "Loading...",
        "loadCon": "Networking...",
        "search": "Search name or position",
        "searchGroup": "Search name",
        "editName": "Name the device",
        "reconfigure": "Reconfigure the devices",
        "aboutDevice": "About devices",
        "otaUpdate": "Firmware update",
        "association": "Device association",
        "editDevice": "Edit the device",
        "editGroup": "Edit the group",
        "addDevice": "Add device",
        "addGroup": "Add group",
        "addPair": "Add pairing",
        "deleteDevice": "Delete device",
        "deviceOnline": "Device online",
        "deviceOffline": "Device offline",
        "groupAll": "All",
        "scanDevice": "Scan the devices",
        "deviceList": "devices ",
        "next": "Next",
        "nextStep": "Next",
        "light": "Light",
        "switch": "Switch",
        "sensor": "Sensor",
        "other": "Other",
        "offline": "Offline",
        "local": "Local network",
        "cloud": "External network",
        "no": "N/A",
        "read": "Reading",
        "athletics": "Workout",
        "dinner": "Dinner",
        "sleep": "Sleep",
        "thinking": "Meditation",
        "work": "Work",
        "recreation": "Entertainment",
        "alarm": "Alarm",
        "love": "Romance",
        "deviceType": "Device type",
        "macAddress": "MAC address",
        "version": "Version",
        "time": "Time",
        "deviceVersion": "Device version",
        "parentNode": "Parent node MAC",
        "rootNode": "Root node MAC",
        "deviceStatus": "Device status",
        "deviceIP": "Device IP",
        "aboutUs": "About us",
        "softwareVersion": "Software version",
        "officialWebsite": "Official website",
        "confirmWIFI": "Confirm the Wi-Fi settings",
        "currentWIFI": "Wi-Fi",
        "selectDevice": "Selected devices",
        "color": "Color",
        "scene": "Lighting theme",
        "set": "Settings",
        "pair": "Pair",
        "checkUpdates": "Check for updates",
        "latestVersion": "latest version ",
        "helpCenter": "Help",
        "network": "Wireless network",
        "accountInfo": "User account",
        "account": "Account",
        "logout": "Log out",
        "location": "Location information",
        "floor": "Floor",
        "area": "Area",
        "code": "Code",
        "topology": "Topology",
        "topologyInfo": "Topological details",

        "editNameDesc": "Edit the device name",
        "editNameInput": "Enter the new device name",
        "listDesc": "The list of the networked devices is shown below:",
        "pairListDesc": "The list of the pairs is shown below:",
        "remindDesc": "Found new devices, Please go to Add.",
        "forgotDesc": "Please enter your email address to reset the password",
        "wifiDesc": "Mesh networking is not available on 5G network",
        "bleConDesc": "Please turn on Bluetooth",
        "locationConDesc": "Please turn on GPS",
        "wifiNoDesc": "Please connect the phone to Wi-Fi",
        "bleConDesc": "Please turn on Bluetooth",
        "meshIdDesc": "Please enter mesh ID!",
        "locationConDesc": "Please turn on GPS",
        "emptyEventDesc": "Sure to disable the device association",
        "connetDeviceDesc": "Devices connection...",
        "connetSuccessDesc": "Devices successfully",
        "connetFailDesc": "Devices fail",
        "deviceOtaDesc": "Choose the devices to be updated",
        "deleteTypeDeviceDesc": "Sure to reset the devices? The devices will be restored to the factory state.",
        "deleteGroupDeviceDesc": "Sure to reset the devices? The devices will be restored to the factory state.",
        "deleteDeviceDesc": "Sure to reset the devices? The devices will be restored to the factory state.",
        "deleteSuccessDesc": "The devices are successfully reset.",
        "deleteFailDesc": "The devices resetting fails.",
        "deleteSelectDesc": "Choose the devices to be reset",
        "addGroupDesc": "Enter the group name",
        "addGroupInput": "Enter the name here",
        "prohibitEditDesc": "The default group name can not be edited",
        "prohibitDelDesc": "The default group can not be deleted",
        "delGroupDesc": "Sure to delete the group?",
        "exitProgramDesc": "Tap again to exit the app",
        "logoutDesc": "Sure to log out?",
        "confailTitleDesc": "Please confirm if",
        "problemDesc1": "the device is placed too far away from the router",
        "problemDesc2": "the Wi-Fi password is correct",
        "problemDesc3": "the device is powered up",
        "problemDesc4": "the device is in the initialized state",
        "causeDesc1": "Please make sure that the devices flashes yellow, or else power on and off the devices for three consecutive times.",
        "causeDesc2": "Please make sure the devices are turned on and nearby",
        "causeDesc3": "Please turn on Bluetooth",
        "causeDesc4": "Please turn on GPS",
        "causeDesc5": "The newly added devices may not show in the list, please kindly wait for a while",
        "causeDesc6": "Reset the devices if the devices are not connected or connected to the wrong network",
        "scanToDesc": "Found",
        "countDeviceDesc": "available devices",
        "associationDesc": "Configure the devices to associate with each other",
        "wifiChangeDesc": "WiFi changes",
        "noDeviceDesc": "There is no device under the current route",

        "pullDownDesc": "Swipe down to refresh",
        "notLoadDesc": "No devices found",
        "emailDesc": "Enter the email address",
        "passwordDesc": "Enter the password",
        "userNameDesc": "Enter the user account",
        "rePasswordDesc": "Enter the password again",
        "differentDesc": "Passwords do not match",
        "floorDesc": "Choose the floor",
        "areaDesc": "Choose the area",
        "codeDesc": "Enter the code",
        "macDesc": "Enter the mac",
        "existCodeDesc": "The entered code already exists in the selected floor area",
        "existMacDesc": "The entered MAC already exists",
        "saveSuccessDesc": "Saved successfully",
        "saveFailDesc": "Failed to save",
        "registerSuccessDesc": "Resgitered successfully",
        "registerFailDesc": "Fail to register",
        "loginFailDesc": "Fail to log in",
        "editSuccessDesc": "Modified",
        "editFailDesc": "Failure",
        "delSuccessDesc": "Delete successfully",
        "delFailDesc": "Delete failed",
        "userNameDesc": "Please enter the user account",
        "rePasswordDesc": "Reenter the password",
        "downloadSuccessDesc": "Downloaded",
        "downloadFailDesc": "Fail to connect to the cloud",
        "sendSuccessDesc": "Sent the email",
        "sendFailDesc": "Fail to send the email",
        "deviceUpgradingDesc": "Devices upgrading...",
        "upgradeSucDesc": "Devices upgraded",
        "upgradepPartSucDesc": "Some devices upgraded",
        "upgradingDesc": "Upgrading",
        "upgradePartFailDesc": "Upgrade fails",
        "upgradeFailDesc": "The devices upgrade fails. Please check your network and try again.",
        "conRouteFailDesc": "Connection route failed",
        "pwdFailDesc": "Wrong password",
        "delInfoDesc": "Are you sure you want to delete this information?",

        "emptyEventTitle": "Clear the association",
        "connetDeviceTitle": "Connect the devices",
        "connetFailTitle": "Connection fails",
        "addGroupTitle": "Add a new group",
        "editGroupTitle": "Edit group name",
        "delGroupTitle": "Delete the group",
        "delInfoTitle": "Delete information",
        "downloadBinTitle": "Download the bin",
        "noShowTitle": "My devices are not displayed here",
        "noShowCauseTitle": "Causes of failure to display the devices",
        "nav":{
            "recent":"Recent",
            "device":"Devices",
            "group":"Group",
            "user":"User"
        }
    }
    return {
        m: m
    };
})