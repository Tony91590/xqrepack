webpackJsonp([14],{Btm0:function(L,t){},UMpG:function(L,t){},fHeX:function(L,t,e){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var a=e("Xxa5"),n=e.n(a),o=e("exGp"),s=e.n(o),r=e("n8t0"),i=e("hNqL"),c={name:"home",data:function(){return{userProtocol:!0,planProtocal:!0,disabledTep:!1,hardware:"",routerData:{}}},created:function(){this.disabled=this.userProtocol?0:1,this.routerInfo(),this.common.setInitLog({type:0,step:"init_web_hello"});var L=this;"-ms-scroll-limit"in document.documentElement.style&&"-ms-ime-align"in document.documentElement.style&&window.addEventListener("hashchange",function(){var t=window.location.hash.slice(1);L.$route.path!==t&&L.$router.replace(t)},!1)},components:{CheckBox:r.a,Toast:i.a},methods:{changeUserProtocol:function(){this.disabledTep=this.userProtocol?0:1},start:function(){this.disabledTep||this.loginInfo()},loginInfo:function(){var L=this;return s()(n.a.mark(function t(){var e,a,o,s;return n.a.wrap(function(t){for(;;)switch(t.prev=t.next){case 0:return e=L.common.Encrypt.init(),a=L.common.Encrypt.oldPwd("admin"),o={username:"admin",logtype:2,nonce:e,password:a,init:1,privacy:L.planProtocal?1:0},t.next=5,L.axios.getLoginInfo(o);case 5:(s=t.sent)&&s.data&&0==s.data.code?(L.common.setCookie("token",s.data.token,1/48),L.$router.push({path:"/guide"})):L.$refs.tip.showTips(s.data.msg||"发生未知错误，请稍后再试~");case 7:case"end":return t.stop()}},t,L)}))()},routerInfo:function(){var L=this;return s()(n.a.mark(function t(){var e,a;return n.a.wrap(function(t){for(;;)switch(t.prev=t.next){case 0:return t.next=2,L.axios.getRouterInfo();case 2:e=t.sent,L.routerData=e.data,L.GLOBAL.hardware=e.data.hardware,L.GLOBAL.routerName=L.common.formatSsidName(e.data.name),L.GLOBAL.mac=e.data.mac,L.common.setCookie("mac",e.data.mac,1/48),L.common.setCookie("hardware",e.data.hardware,1/48),a=L.common.formatSsidName(e.data.name),L.common.setCookie("ssid_name",a,1/48),L.common.getCookie("hardware");case 12:case"end":return t.stop()}},t,L)}))()},agreement:function(){this.$router.push({path:"/agreement"})},privacy:function(){this.$router.push({path:"/privacy"})}}},C={render:function(){var L=this,t=L.$createElement,e=L._self._c||t;return e("div",{staticClass:"container"},[e("div",{staticClass:"title"},[e("svg",{attrs:{viewBox:"0 0 540 238",version:"1.1",xmlns:"http://www.w3.org/2000/svg","xmlns:xlink":"http://www.w3.org/1999/xlink"}},[e("defs",[e("linearGradient",{attrs:{x1:"16.7947049%",y1:"81.6162109%",x2:"71.6341146%",y2:"0%",id:"linearGradient-1"}},[e("stop",{attrs:{"stop-color":"#79F1FF",offset:"0%"}}),L._v(" "),e("stop",{attrs:{"stop-color":"#3C94FF",offset:"100%"}})],1)],1),L._v(" "),e("g",{attrs:{id:"",stroke:"none","stroke-width":"1",fill:"none","fill-rule":"evenodd"}},[e("path",{attrs:{d:"M32.024,204.984 L34.076,203.796 C36.272011,206.208012 38.8459852,209.321981 41.798,213.138 C43.7780099,208.385976 45.0199975,203.256028 45.524,197.748 L31.7,197.748 L31.7,195.534 L48.062,195.534 L48.062,197.532 C47.269996,204.084033 45.7040117,209.987974 43.364,215.244 C45.956013,218.664017 48.0979915,221.669987 49.79,224.262 L48.008,225.99 C46.7479937,223.97399 44.822013,221.184018 42.23,217.62 C39.5299865,222.732026 36.0200216,227.213981 31.7,231.066 C31.0159966,230.561997 30.1160056,230.184001 29,229.932 C33.7880239,226.295982 37.6579852,221.50803 40.61,215.568 C36.6499802,210.347974 33.7880088,206.820009 32.024,204.984 Z M63.236,205.416 C63.236,207.756012 63.1640007,209.95199 63.02,212.004 C65.3600117,222.912055 70.7239581,230.453979 79.112,234.63 C77.9959944,235.134003 77.1500029,235.835996 76.574,236.736 C69.6619654,232.523979 64.8740133,226.044044 62.21,217.296 C60.1939899,226.368045 54.8300436,233.117978 46.118,237.546 C45.2539957,236.609995 44.4440038,235.998001 43.688,235.71 C53.2280477,231.605979 58.7899921,224.56805 60.374,214.596 C60.6620014,212.867991 60.806,209.718023 60.806,205.146 L63.236,205.416 Z M57.782,189 L60.158,189.81 C59.7259978,192.078011 59.0240049,194.759985 58.052,197.856 L75.98,197.856 L75.98,199.692 L71.984,210.06 C71.0479953,209.771999 70.2200036,209.646 69.5,209.682 L73.28,200.07 L57.296,200.07 C55.495991,205.110025 53.4620113,209.177985 51.194,212.274 C50.0779944,211.841998 49.1600036,211.608 48.44,211.572 C53.048023,205.883972 56.1619919,198.360047 57.782,189 Z M84.188,206.874 L93.908,206.874 L93.908,227.502 C97.5440182,230.526015 101.773976,232.271998 106.598,232.74 C114.55404,233.424003 123.229953,233.442003 132.626,232.794 C132.013997,233.514004 131.618001,234.467994 131.438,235.656 C127.801982,235.764001 124.00402,235.8 120.044,235.764 C116.299981,235.764 113.204012,235.692001 110.756,235.548 C103.159962,235.331999 97.1840218,233.316019 92.828,229.5 C89.8399851,232.452015 87.8240052,234.755992 86.78,236.412 L84.728,234.63 C86.6720097,232.325988 88.9219872,230.004012 91.478,227.664 L91.478,209.142 L84.188,209.142 L84.188,206.874 Z M115.076,194.13 L129.062,194.13 L129.062,218.106 C129.098,221.598017 127.244019,223.326 123.5,223.29 C122.383994,223.29 121.340005,223.218001 120.368,223.074 C120.332,222.353996 120.134002,221.544005 119.774,220.644 C121.070006,220.860001 122.257995,220.986 123.338,221.022 C125.678012,221.094 126.812,220.032011 126.74,217.836 L126.74,196.236 L117.452,196.236 L117.452,230.364 L115.076,230.364 L115.076,194.13 Z M114.536,192.726 C110.971982,194.022006 107.516017,194.921997 104.168,195.426 L104.168,220.59 L111.35,216.81 L112.484,218.484 L104.762,222.858 C104.69,222.894 104.582001,222.965999 104.438,223.074 C103.357995,223.722003 102.530003,224.315997 101.954,224.856 L100.442,223.02 C101.378005,222.191996 101.828,220.932008 101.792,219.24 L101.792,193.428 C105.572019,193.067998 109.315981,192.168007 113.024,190.728 L114.536,192.726 Z M86.078,193.59 L88.022,192.132 C91.0460151,194.400011 93.7819878,196.847987 96.23,199.476 L94.826,201.636 C92.017986,198.719985 89.1020151,196.038012 86.078,193.59 Z M155.36,221.238 L156.926,219.564 C159.086011,223.020017 161.587986,225.70199 164.432,227.61 C166.268009,225.305988 167.311999,222.102021 167.564,217.998 L155.414,217.998 L155.414,205.2 L167.672,205.2 L167.672,198.774 L152.93,198.774 L152.93,196.56 L167.672,196.56 L167.672,189.324 L170.102,189.324 L170.102,196.56 L184.736,196.56 L184.736,198.774 L170.102,198.774 L170.102,205.2 L182.36,205.2 L182.36,217.998 L169.94,217.998 C169.651999,222.534023 168.50001,226.133987 166.484,228.798 C168.248009,229.770005 170.15599,230.525997 172.208,231.066 C176.16802,232.254006 181.15397,233.063998 187.166,233.496 C186.517997,234.288004 186.050001,235.151995 185.762,236.088 C179.74997,235.295996 175.142016,234.414005 171.938,233.442 C169.345987,232.793997 167.00601,231.858006 164.918,230.634 C162.253987,233.334014 158.096028,235.583991 152.444,237.384 C151.831997,236.663996 151.094004,236.088002 150.23,235.656 C156.31403,233.71199 160.525988,231.606011 162.866,229.338 C159.949985,227.28599 157.44801,224.586017 155.36,221.238 Z M149.906,189.27 L152.228,190.62 C151.039994,194.004017 149.618008,197.297984 147.962,200.502 L147.962,237.384 L145.532,237.384 L145.532,204.93 C143.47999,208.386017 141.554009,211.06799 139.754,212.976 C138.925996,212.435997 138.062005,212.094001 137.162,211.95 C142.994029,205.469968 147.241987,197.910043 149.906,189.27 Z M180.038,207.306 L170.102,207.306 L170.102,214.434 C170.102,214.902002 170.084,215.387997 170.048,215.892 L180.038,215.892 L180.038,207.306 Z M157.736,207.306 L157.736,215.892 L167.672,215.892 L167.672,207.306 L157.736,207.306 Z M198.182,192.132 L234.686,192.132 L234.686,231.12 C234.686,234.900019 232.832019,236.79 229.124,236.79 C228.079995,236.79 226.838007,236.718001 225.398,236.574 C225.326,235.709996 225.038003,234.864004 224.534,234.036 C226.47801,234.288001 227.899995,234.414 228.8,234.414 C231.140012,234.45 232.292,233.244012 232.256,230.796 L232.256,220.698 L217.406,220.698 L217.406,235.386 L214.922,235.386 L214.922,220.698 L200.45,220.698 C200.053998,227.754035 198.344015,233.31598 195.32,237.384 C194.599996,236.951998 193.700005,236.682001 192.62,236.574 C194.70801,233.765986 196.147996,230.814015 196.94,227.718 C197.768004,224.621985 198.182,220.482026 198.182,215.298 L198.182,192.132 Z M217.406,207.468 L217.406,218.484 L232.256,218.484 L232.256,207.468 L217.406,207.468 Z M232.256,194.346 L217.406,194.346 L217.406,205.254 L232.256,205.254 L232.256,194.346 Z M200.612,215.406 C200.612,215.766002 200.594,216.305996 200.558,217.026 L200.558,218.484 L214.922,218.484 L214.922,207.468 L200.612,207.468 L200.612,215.406 Z M200.612,194.346 L200.612,205.254 L214.922,205.254 L214.922,194.346 L200.612,194.346 Z M255.53,201.366 L258.068,202.662 C255.583988,213.138052 252.398019,221.543968 248.51,227.88 C247.789996,227.555998 246.818006,227.358 245.594,227.286 C250.346024,219.437961 253.657991,210.798047 255.53,201.366 Z M269.408,189.702 L271.946,189.702 L271.946,231.12 C271.946,235.008019 269.93002,236.952 265.898,236.952 C264.313992,236.952 262.748008,236.826001 261.2,236.574 C261.055999,235.637995 260.768002,234.774004 260.336,233.982 C262.496011,234.342002 264.223994,234.522 265.52,234.522 C268.220014,234.630001 269.516001,233.424013 269.408,230.904 L269.408,189.702 Z M281.342,202.446 L283.934,201.798 C288.00202,210.186042 291.583985,218.483959 294.68,226.692 L292.358,228.204 C288.649981,218.15995 284.978018,209.574036 281.342,202.446 Z M322.868,189.324 L325.46,189.324 L325.46,209.358 L345.818,209.358 L345.818,211.734 L327.242,211.734 C332.210025,220.086042 339.229955,226.25998 348.302,230.256 C347.329995,230.760003 346.556003,231.479995 345.98,232.416 C336.295952,227.267974 329.45602,220.464042 325.46,212.004 L325.46,237.384 L322.868,237.384 L322.868,212.004 C319.087981,220.464042 312.248049,227.501972 302.348,233.118 C301.627996,232.253996 300.818004,231.552003 299.918,231.012 C309.386047,226.475977 316.441977,220.050042 321.086,211.734 L302.618,211.734 L302.618,209.358 L322.868,209.358 L322.868,189.324 Z M339.77,194.346 L341.876,195.588 C338.491983,200.016022 335.234016,203.561987 332.102,206.226 C331.525997,205.649997 330.824004,205.254001 329.996,205.038 C333.596018,201.977985 336.853985,198.41402 339.77,194.346 Z M306.668,195.912 L308.774,194.67 C311.798015,197.514014 314.785985,200.645983 317.738,204.066 L316.28,206.01 C312.895983,202.08598 309.692015,198.720014 306.668,195.912 Z M357.32,192.672 L372.872,192.672 L372.872,207.36 L366.824,207.36 L366.824,215.622 L372.872,215.622 L372.872,217.728 L366.824,217.728 L366.824,229.068 L373.682,227.07 L374.708,228.96 L354.674,235.008 L353.108,233.064 L357.212,231.822 L357.212,213.354 L359.534,213.354 L359.534,231.174 L364.502,229.716 L364.502,207.36 L357.32,207.36 L357.32,192.672 Z M377.192,218.322 L397.01,218.322 L397.01,237.384 L394.688,237.384 L394.688,234.09 L379.514,234.09 L379.514,237.384 L377.192,237.384 L377.192,218.322 Z M382.97,189.216 L385.13,190.458 C384.733998,191.754006 384.122004,193.193992 383.294,194.778 L398.09,194.778 L398.09,196.506 C396.00199,200.826022 393.086019,204.731983 389.342,208.224 C393.554021,211.356016 398.251974,213.587993 403.436,214.92 C402.607996,215.496003 401.942003,216.251995 401.438,217.188 C396.145974,215.387991 391.50202,212.904016 387.506,209.736 C384.229984,212.400013 380.198024,214.829989 375.41,217.026 C374.905997,216.305996 374.204004,215.748002 373.304,215.352 C377.660022,213.731992 381.79998,211.356016 385.724,208.224 C383.347988,206.13599 381.260009,203.742013 379.46,201.042 C378.199994,202.734008 377.084005,204.011996 376.112,204.876 C375.391996,204.371997 374.618004,204.030001 373.79,203.85 C377.78602,199.88998 380.845989,195.012029 382.97,189.216 Z M379.514,220.428 L379.514,231.984 L394.688,231.984 L394.688,220.428 L379.514,220.428 Z M370.55,194.778 L359.642,194.778 L359.642,205.254 L370.55,205.254 L370.55,194.778 Z M395.39,196.884 L382.16,196.884 C381.727998,197.676004 381.260003,198.431996 380.756,199.152 C382.66401,202.032014 384.913987,204.551989 387.506,206.712 C391.142018,203.471984 393.769992,200.196017 395.39,196.884 Z M430.868,189.378 L433.352,189.378 L433.352,200.124 L451.118,200.124 L451.118,237.384 L448.688,237.384 L448.688,233.226 L415.64,233.226 L415.64,237.384 L413.21,237.384 L413.21,200.124 L430.868,200.124 L430.868,189.378 Z M433.352,217.728 L433.352,231.012 L448.688,231.012 L448.688,217.728 L433.352,217.728 Z M415.64,217.728 L415.64,231.012 L430.868,231.012 L430.868,217.728 L415.64,217.728 Z M448.688,202.338 L433.352,202.338 L433.352,215.514 L448.688,215.514 L448.688,202.338 Z M415.64,202.338 L415.64,215.514 L430.868,215.514 L430.868,202.338 L415.64,202.338 Z M488.54,221.562 L505.226,221.562 L505.226,237.384 L503.012,237.384 L503.012,234.36 L490.754,234.36 L490.754,237.384 L488.54,237.384 L488.54,221.562 Z M467.318,221.562 L483.896,221.562 L483.896,237.384 L481.682,237.384 L481.682,234.36 L469.532,234.36 L469.532,237.384 L467.318,237.384 L467.318,221.562 Z M463.916,209.736 L483.95,209.736 C484.670004,208.295993 485.173999,206.58601 485.462,204.606 L487.676,205.254 C487.351998,207.054009 486.920003,208.547994 486.38,209.736 L498.53,209.736 C496.693991,208.511994 495.002008,207.522004 493.454,206.766 L495.02,205.47 C497.216011,206.514005 499.159992,207.701993 500.852,209.034 L500.42,209.736 L508.358,209.736 L508.358,211.896 L489.836,211.896 C495.272027,216.180021 502.417956,218.286 511.274,218.214 C510.553996,219.114005 510.068001,219.959996 509.816,220.752 C499.267947,219.959996 491.636024,217.008026 486.92,211.896 L485.3,211.896 C481.555981,217.116026 474.212055,220.103996 463.268,220.86 C462.835998,220.103996 462.260004,219.402003 461.54,218.754 C471.404049,218.321998 478.35198,216.036021 482.384,211.896 L463.916,211.896 L463.916,209.736 Z M488.81,192.132 L505.172,192.132 L505.172,204.876 L488.81,204.876 L488.81,192.132 Z M467.372,192.132 L483.68,192.132 L483.68,204.876 L467.372,204.876 L467.372,192.132 Z M490.754,223.56 L490.754,232.362 L503.012,232.362 L503.012,223.56 L490.754,223.56 Z M469.532,223.56 L469.532,232.362 L481.682,232.362 L481.682,223.56 L469.532,223.56 Z M502.958,194.13 L491.024,194.13 L491.024,202.878 L502.958,202.878 L502.958,194.13 Z M481.466,194.13 L469.586,194.13 L469.586,202.878 L481.466,202.878 L481.466,194.13 Z M434.676066,73.4997668 L434.676066,144 L427.2,144 L427.2,3.74941707 L427.2,0 L524.4,0 L524.4,7.49883414 L434.676066,7.49883414 L434.676066,66.0009327 L510.943081,66.0009327 L510.943081,73.4997668 L434.676066,73.4997668 Z M287.92913,62.9208145 L253.263382,144 L245.580291,144 L187.2,0 L194.883091,0 L249.520395,135.095414 L284.186143,53.6670294 L288.079207,44.2968444 L307.038298,0 L314.716909,0 L291.869234,53.6670294 L324.803486,135.095414 L382.316909,0 L390,0 L328.546473,144 L320.863382,144 L287.92913,62.9208145 Z M168,144 L168,39.6 L175.2,39.6 L175.2,144 L168,144 Z M168,17.7447377 L168,3.85755167 C168,1.72387917 169.611684,0 171.598927,0 C173.588316,0 175.2,1.72387917 175.2,3.85755167 L175.2,17.7447377 C175.2,19.8715421 173.588316,21.6 171.598927,21.6 C169.611684,21.6 168,19.8715421 168,17.7447377 Z M404.4,144 L404.4,40.8 L411.6,40.8 L411.6,144 L404.4,144 Z M404.4,16.7575312 L404.4,3.64246882 C404.4,1.62878158 406.011684,0 408.001073,0 C409.988316,0 411.6,1.62878158 411.6,3.64246882 L411.6,16.7575312 C411.6,18.7668692 409.988316,20.4 408.001073,20.4 C406.011684,20.4 404.4,18.7668692 404.4,16.7575312 Z M532.8,144 L532.8,39.6 L540,39.6 L540,144 L532.8,144 Z M532.8,17.7447377 L532.8,3.85755167 C532.8,1.72387917 534.409538,0 536.398927,0 C538.38617,0 540,1.72387917 540,3.85755167 L540,17.7447377 C540,19.8715421 538.38617,21.6 536.398927,21.6 C534.409538,21.6 532.8,19.8715421 532.8,17.7447377 Z M71.2874385,144 L7.50111757,13.4979014 L7.50111757,144 L0,144 L0,0 L9.20205633,0 L74.8077783,137.387595 L141.041574,0 L150,0 L150,144 L142.501118,144 L142.501118,12.5174569 L78.2565937,144 L71.2874385,144 Z",id:"Combined-Shape",fill:"url(#linearGradient-1)"}})])])]),L._v(" "),e("div",{staticClass:"footer width100"},[e("div",{staticClass:"user"},[e("div",[e("CheckBox",{attrs:{name:"protocal"},on:{change:L.changeUserProtocol},model:{value:L.userProtocol,callback:function(t){L.userProtocol=t},expression:"userProtocol"}}),L._v(" "),e("span",[L._v("已阅读并同意小米路由器")]),L._v(" "),e("a",{attrs:{href:"javascript:void(0)"},on:{click:L.agreement}},[L._v("《用户许可使用协议》")])],1),L._v(" "),e("div",[e("CheckBox",{attrs:{name:"protocal"},model:{value:L.planProtocal,callback:function(t){L.planProtocal=t},expression:"planProtocal"}}),L._v("已加入\n                  "),e("a",{attrs:{href:"javascript:void(0)"},on:{click:L.privacy}},[L._v("《用户体验改善计划》")])],1)]),L._v(" "),e("div",{staticClass:"join"},[e("a",{staticClass:"button",class:{disabled:L.disabledTep},attrs:{href:"javascript:void(0)",disabled:L.disabledTep},on:{click:L.start}},[L._v("马上体验")])]),L._v(" "),e("div",{staticClass:"desc"},[L._v("\n          版权所有 小米移动软件有限公司\n      ")])]),L._v(" "),e("Toast",{ref:"tip"})],1)},staticRenderFns:[]};var d=e("VU/8")(c,C,!1,function(L){e("i8tY")},"data-v-eb6a0750",null);t.default=d.exports},hNqL:function(L,t,e){"use strict";var a={name:"tip",props:{},data:function(){return{showTip:!1,desc:""}},methods:{showTips:function(L){var t=this;t.showTip=!0,t.desc=L,setTimeout(function(){t.showTip=!1},2e3)}}},n={render:function(){var L=this.$createElement;return(this._self._c||L)("div",{directives:[{name:"show",rawName:"v-show",value:this.showTip,expression:"showTip"}],staticClass:"wireless_failure"},[this._v("\n    "+this._s(this.desc)+"\n")])},staticRenderFns:[]};var o=e("VU/8")(a,n,!1,function(L){e("UMpG")},"data-v-77ab80be",null);t.a=o.exports},i8tY:function(L,t){},n8t0:function(L,t,e){"use strict";var a={name:"checkbox",model:{prop:"checked",event:"change"},props:{name:{type:String,default:""},checked:Boolean,value:String},methods:{onChange:function(L){this.$emit("change",L.target.checked)}},watch:{},mounted:function(){}},n={render:function(){var L=this,t=L.$createElement;return(L._self._c||t)("input",{staticClass:"iconfont checkbox",attrs:{name:L.name,type:"checkbox"},domProps:{value:L.value,checked:L.checked},on:{change:function(t){L.onChange(t)}}})},staticRenderFns:[]};var o=e("VU/8")(a,n,!1,function(L){e("Btm0")},null,null);t.a=o.exports}});