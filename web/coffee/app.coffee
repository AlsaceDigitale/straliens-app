@App = angular.module 'straliens', ['ui.router', 'uiGmapgoogle-maps', 'ngWebSocket', 'ui.bootstrap', 'ngCookies']
App.config (uiGmapGoogleMapApiProvider) ->
    uiGmapGoogleMapApiProvider.configure {
        v: '3.17'
        libraries: 'visualization'
    }

App.config [
    '$httpProvider'
    ($httpProvider) ->
        # Use x-www-form-urlencoded Content-Type
        $httpProvider.defaults.headers.post['Content-Type'] = 'application/x-www-form-urlencoded;charset=utf-8'

        ###*
        # The workhorse; converts an object to x-www-form-urlencoded serialization.
        # @param {Object} obj
        # @return {String}
        ###

        param = (obj) ->
            query = ''
            name = undefined
            value = undefined
            fullSubName = undefined
            subName = undefined
            subValue = undefined
            innerObj = undefined
            i = undefined
            for name of obj
                value = obj[name]
                if value instanceof Array
                    i = 0
                    while i < value.length
                        subValue = value[i]
                        fullSubName = name + '[' + i + ']'
                        innerObj = {}
                        innerObj[fullSubName] = subValue
                        query += param(innerObj) + '&'
                        ++i
                else if value instanceof Object
                    for subName of value
                        subValue = value[subName]
                        fullSubName = name + '[' + subName + ']'
                        innerObj = {}
                        innerObj[fullSubName] = subValue
                        query += param(innerObj) + '&'
                else if value != undefined and value != null
                    query += encodeURIComponent(name) + '=' + encodeURIComponent(value) + '&'
            if query.length then query.substr(0, query.length - 1) else query

        # Override $http service's default transformRequest
        $httpProvider.defaults.transformRequest = [ (data) ->
            if angular.isObject(data) and String(data) != '[object File]' then param(data) else data
        ]
]

App.config ($stateProvider, $urlRouterProvider) ->
    $urlRouterProvider.otherwise '/play'

    $stateProvider
    .state 'play',
        url: '/play'
        controller: 'playCtrl'
        title: 'Accueil'

    .state 'login',
        url: '/login'
        controller: 'loginCtrl'
        title: 'Login'
        templateUrl: '/partials/login.html'

    .state 'signup',
        url: '/signup'
        controller: 'signupCtrl'
        title: 'SignUp'
        templateUrl: '/partials/signup.html'

    .state 'check',
        url: '/check/:id'
        controller: 'checkCtrl'
        title: 'check'
        templateUrl: '/partials/check.html'


# Main controller
# ---------------
App.controller 'appCtrl', [
    '$scope'
    ($scope) ->
]

# Check controller
# ---------------
App.controller 'checkCtrl', [
    '$scope'
    '$http'
    '$state'
    ($scope, $http, $state) ->
        $http
            url: 'http://localhost:3000/api/point/#{$state.params.id}/check/'
            method: 'GET'
            withCredentials: true

        .success (data) ->
            $state.go 'play'
]

# Index page controller
# ---------------------
App.controller 'playCtrl', [
    '$rootScope'
    '$scope'
    '$http'
    '$state'
    'uiGmapGoogleMapApi'
    ($rootScope, $scope, $http, $state, uiGmapGoogleMapApi) ->

        if !$rootScope.validUser()
            $state.go 'login'

        #$rootScope.socket.on 'notification:post', (msg, obj) ->
        #    console.log msg, obj

#        $http.get "http://localhost:3000/api/points"
#        .success (data) ->
#            data.forEach (obj, key) ->
#                $http.get "http://localhost:3000/api/points/"+ obj.id
#                .success (data) ->
#                    obj.coordinates = { latitude: obj.lat, longitude: obj.lng }
#                    obj.options = {
#                        labelContent: Math.abs(data.energy)
#                        labelAnchor: "0 0"
#                        labelClass: 'map-label side-' + data.side
#                    }

        # DEBUG
        $scope.points = [
            {
                "id": 1,
                "name": "",
                "code": "UEAJFZCM",
                "latitude": 48.5870549,
                "longitude": 7.7464128
            }, {
                "id": 2,
                "name": "",
                "code": "4SQK4UUQ",
                "latitude": 48.5818526,
                "longitude": 7.751036899999999
            }, {
                "id": 3,
                "name": "",
                "code": "G8P3TULX",
                "latitude": 48.5827682,
                "longitude": 7.7410269000000005
            }, {
                "id": 4,
                "name": "",
                "code": "QB352GKM",
                "latitude": 48.5832224,
                "longitude": 7.7533864999999995
            }, {
                "id": 5,
                "name": "",
                "code": "WVC8WDDQ",
                "latitude": 48.5855787,
                "longitude": 7.7477646
            }, {
                "id": 6,
                "name": "",
                "code": "2JV3NHL0",
                "latitude": 48.5849542,
                "longitude": 7.741670600000001
            }, {
                "id": 7,
                "name": "",
                "code": "WK1E6RUN",
                "latitude": 48.581519,
                "longitude": 7.743558900000001
            }, {
                "id": 8,
                "name": "",
                "code": "KI6ISVBP",
                "latitude": 48.5835631,
                "longitude": 7.7489877
            }, {
                "id": 9,
                "name": "",
                "code": "D62D5T4H",
                "latitude": 48.5837334,
                "longitude": 7.744245599999999
            }, {
                "id": 10,
                "name": "",
                "code": "IDVWMSOR",
                "latitude": 48.5819165,
                "longitude": 7.747678799999999
            }, {
                "id": 11,
                "name": "",
                "code": "J897K812",
                "latitude": 48.5834353,
                "longitude": 7.7457047
            }, {
                "id": 12,
                "name": "",
                "code": "N6JJU4AP",
                "latitude": 48.5804969,
                "longitude": 7.7499533
            }, {
                "id": 13,
                "name": "",
                "code": "GAOE5ZAD",
                "latitude": 48.5859194,
                "longitude": 7.750897400000001
            }, {
                "id": 14,
                "name": "",
                "code": "WTY5AI3E",
                "latitude": 48.580610500000006,
                "longitude": 7.743344300000001
            }, {
                "id": 15,
                "name": "",
                "code": "QN3C8OJW",
                "latitude": 48.5818313,
                "longitude": 7.754716900000001
            }, {
                "id": 16,
                "name": "",
                "code": "JBDS1LK3",
                "latitude": 48.5812351,
                "longitude": 7.7405548
            }, {
                "id": 17,
                "name": "",
                "code": "2WL1KMHD",
                "latitude": 48.5798723,
                "longitude": 7.7444172
            }, {
                "id": 18,
                "name": "",
                "code": "I0H0B93G",
                "latitude": 48.579418,
                "longitude": 7.7468634
            }, {
                "id": 19,
                "name": "",
                "code": "O8P2U16Z",
                "latitude": 48.5847554,
                "longitude": 7.73592
            }, {
                "id": 20,
                "name": "",
                "code": "P2V90ARG",
                "latitude": 48.58526640000001,
                "longitude": 7.752742799999999
            }, {
                "id": 21,
                "name": "",
                "code": "92TAX99J",
                "latitude": 48.58407410000001,
                "longitude": 7.7501249
            }, {
                "id": 22,
                "name": "",
                "code": "68CIHL4Y",
                "latitude": 48.5846135,
                "longitude": 7.7459192
            }, {
                "id": 23,
                "name": "",
                "code": "K1KC8RFE",
                "latitude": 48.58526640000001,
                "longitude": 7.754631000000001
            }, {
                "id": 24,
                "name": "",
                "code": "VAB1J0BS",
                "latitude": 48.5847838,
                "longitude": 7.7615404
            }, {
                "id": 25,
                "name": "",
                "code": "SANEVODB",
                "latitude": 48.5793328,
                "longitude": 7.7588367
            }, {
                "id": 26,
                "name": "",
                "code": "16F14QOC",
                "latitude": 48.5784527,
                "longitude": 7.755918500000001
            }, {
                "id": 27,
                "name": "",
                "code": "JH32AW35",
                "latitude": 48.5783675,
                "longitude": 7.7617979
            }, {
                "id": 28,
                "name": "",
                "code": "Z9MTY8LQ",
                "latitude": 48.5788218,
                "longitude": 7.751240700000001
            }, {
                "id": 29,
                "name": "",
                "code": "ZL8CPD69",
                "latitude": 48.5810363,
                "longitude": 7.760381700000001
            }, {
                "id": 30,
                "name": "",
                "code": "A1QG98V5",
                "latitude": 48.5871401,
                "longitude": 7.7538156
            }, {
                "id": 31,
                "name": "",
                "code": "HX3XC6NE",
                "latitude": 48.5833643,
                "longitude": 7.7589226
            }, {
                "id": 32,
                "name": "",
                "code": "V48L070O",
                "latitude": 48.581377,
                "longitude": 7.758150100000001
            }, {
                "id": 33,
                "name": "",
                "code": "83YXX41L",
                "latitude": 48.5821436,
                "longitude": 7.759823800000001
            }, {
                "id": 34,
                "name": "",
                "code": "VYAD7XHY",
                "latitude": 48.5802698,
                "longitude": 7.756948500000001
            }, {
                "id": 35,
                "name": "",
                "code": "98HV62QC",
                "latitude": 48.5813699,
                "longitude": 7.7621305
            }, {
                "id": 36,
                "name": "",
                "code": "NRCUPI85",
                "latitude": 48.5791909,
                "longitude": 7.761207800000001
            }, {
                "id": 37,
                "name": "",
                "code": "N42YZ7MC",
                "latitude": 48.578907,
                "longitude": 7.7664328
            }, {
                "id": 38,
                "name": "",
                "code": "DRGWCHGF",
                "latitude": 48.5768059,
                "longitude": 7.756991400000001
            }, {
                "id": 39,
                "name": "",
                "code": "IXLEXK9T",
                "latitude": 48.57439240000001,
                "longitude": 7.7589226
            }, {
                "id": 40,
                "name": "",
                "code": "MOHQ6NSB",
                "latitude": 48.5738245,
                "longitude": 7.7652311
            }
        ]

        # TODO
        $scope.points.forEach (obj, key) ->
            obj.team = if Math.random() > 0.5 then "straliens" else "terriens"
            obj.power = Math.round (Math.random() * 100)
            obj.options = {
                labelContent: obj.power
                labelClass: 'map-label side-' + obj.team
            }
            obj.icon =
                path: ''


        $scope.map =
            zoom: 15
            center:
                #center on cathedrale
                latitude: 48.5819
                longitude: 7.75104
            options:
                minZoom: 15
                maxZoom: 20
                panControl: false
                zoomControl: true
                mapTypeControl: false
                scaleControl: false
                streetViewControl: false
                overviewMapControl: false
                mapTypeControl: false
            events:
                center_changed: (map) ->
                    allowedBounds =
                        sw: [48.572579, 7.732542]
                        ne: [48.589705, 7.775301]
                    C = map.getCenter()
                    if C.lng() > allowedBounds.ne[1] || C.lng() < allowedBounds.sw[1] || C.lat() > allowedBounds.ne[0] || C.lat() < allowedBounds.sw[0]
                        X = C.lng()
                        Y = C.lat()

                        AmaxX = allowedBounds.ne[1]
                        AmaxY = allowedBounds.ne[0]
                        AminX = allowedBounds.sw[1]
                        AminY = allowedBounds.sw[0]

                        if (X < AminX)
                            X = AminX
                        if (X > AmaxX)
                            X = AmaxX
                        if (Y < AminY)
                            Y = AminY
                        if (Y > AmaxY)
                            Y = AmaxY

                        map.panTo {lat: Y, lng: X}
]

App.controller 'loginCtrl', [
    '$rootScope'
    '$scope'
    '$state'
    '$http'
    '$cookies'
    ($rootScope, $scope, $state, $http, $cookies) ->
        $scope.showTeamPwd = false

        $scope.onSelect = ($item) ->
            $scope.team = $item
            $scope.showTeamPwd = true

        $scope.validate = (form) ->
            $http
                withCredentials: true
                url: "http://localhost:3000/api/services/login?sections=team",
                method: "POST"
                data:
                    nickname: form.nickname
                    password: form.password
            .success (data) ->
                $rootScope.user.id = data.id
                $rootScope.user.name = data.nickname
                $rootScope.user.teamId = data.teamId
                $rootScope.user.team = data.team

                $cookies.putObject("user", $rootScope.user)
                $rootScope.socket = io("ws://127.0.0.1:3000")

                $state.go 'play'
            .error (data) ->
                # TODO: make something with the error
                console.log data
]


App.controller 'signupCtrl', [
    '$rootScope'
    '$scope'
    '$state'
    '$http'
    '$cookies'
    ($rootScope, $scope, $state, $http, $cookies) ->
        $scope.showTeamPwd = false

        $http.get "http://localhost:3000/api/teams"
        .success (data) ->
            if !data or data.length == 0
                data = [
                    "straliens"
                    "terrien"
                ]
            $scope.teams = data

        $scope.create = (form) ->
            $http.post 'http://localhost:3000/api/users?sections=team',
                nickname: form.nickname
                email: form.email
                password: form.password
            .success (data) ->
                $rootScope.user.id = data.id
                $rootScope.user.name = data.nickname
                $rootScope.user.teamId = data.teamId
                $rootScope.user.team = data.team

                $cookies.putObject("user", $rootScope.user)
                $rootScope.socket = io("ws://127.0.0.1:3000")

                $state.go 'play'
            .error (data) ->
                # TODO: make something with the error
                console.log data
]

# RUN !!
# ------
App.run [
    '$rootScope'
    '$state'
    '$window'
    '$websocket'
    '$cookies'
    ($rootScope, $state, $window, $websocket, $cookies) ->
        $rootScope.$state = $state
        $rootScope.$cookies = $cookies

        # TODO: récupérer le temps restant
        $rootScope.endTime = '00H00'

        $rootScope.user = if $cookies.getObject('user') then $cookies.getObject('user') else
            team: null
            teamId: -1
            score: 0
            energy: 0

        $rootScope.validUser = () ->
            # TODO : check with token/whatever
            return !!$rootScope.user.name
]