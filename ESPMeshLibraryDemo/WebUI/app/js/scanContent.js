define(["vue","MINT", "txt!../../pages/scanContent.html"],
    function(v, MINT, scanInfo) {

        var ScanInfo = v.extend({

            template: scanInfo,
            props: {

            },
            data: function(){
                return {
                    addFlag: false,
                    snifferList: [],
                    scanType: SNIFFER_TYPE,
                }
            },
            computed: {
                list: function () {
                    return this.snifferList;
                }
            },
            methods:{
                show: function() {
                    var self = this;
                    window.onBackPressed = self.hide;
                    self.addFlag = true;
                    self.snifferList = [];
                    MINT.Indicator.open();
                    setTimeout(function() {
                        var res = window.espmesh.loadSniffers();
                        MINT.Indicator.close();
                        self.loadData(res);
                        window.espmesh.startScanSniffer();
                    },1000)
                },
                hide: function () {
                    this.addFlag = false;
                    this.$emit("scanContentShow");
                    setTimeout(function() {
                        window.espmesh.stopScanSniffer();
                    },10)
                },
                getType: function(value) {
                    var val = "";
                    $.each(SNIFFER_TYPE, function(i, item) {
                        if (item.value == value) {
                            val = item.label;
                            return false;
                        }
                    });
                    return val;
                },
                loadData: function(sniffers) {
                    var self = this;
                    if (!this._isEmpty(sniffers)) {
                        sniffers = JSON.parse(sniffers);
                        $.each(sniffers, function(i, item) {
                            if (i < 50) {
                                self.snifferList.push(item);
                            } else {
                                return false;
                            }

                        });
                    }
                },
                onSniffersDiscovered: function(sniffers) {
                    var self = this;
                    if (!self._isEmpty(sniffers)) {
                        sniffers = JSON.parse(sniffers);
                        $.each(sniffers, function(i, item) {
                            if (self.snifferList.length >= 50) {
                                self.snifferList.splice(50, 1);
                            }
                            self.snifferList.unshift(item);
                        });
                    }
                },
                format: function (fmt, date) {
                    date = new Date(date);
                    var o = {
                        "M+" : date.getMonth()+1,                 //月份
                        "d+" : date.getDate(),                    //日
                        "h+" : date.getHours(),                   //小时
                        "m+" : date.getMinutes(),                 //分
                        "s+" : date.getSeconds(),                 //秒
                        "q+" : Math.floor((date.getMonth()+3)/3), //季度
                        "S"  : date.getMilliseconds()             //毫秒
                    };
                    if(/(y+)/.test(fmt)) {
                        fmt=fmt.replace(RegExp.$1, (date.getFullYear()+"").substr(4 - RegExp.$1.length));
                    }
                    for(var k in o) {
                        if(new RegExp("("+ k +")").test(fmt)){
                            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));
                        }
                    }
                    return fmt;
                },
                _isEmpty: function (str) {
                    if (str === "" || str === null || str === undefined ) {
                        return true;
                    } else {
                        return false;
                    }
                },
            },
            created: function () {
                 window.onSniffersDiscovered = this.onSniffersDiscovered;
            },

        });

        return ScanInfo;
    });