@App = angular.module 'straliens', ['ui.router', 'uiGmapgoogle-maps', 'ngWebSocket', 'ui.bootstrap']
App.config (uiGmapGoogleMapApiProvider) ->
    uiGmapGoogleMapApiProvider.configure {
        v: '3.17'
        libraries: 'visualization'
    }

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
        templateUrl: 'partials/login.html'

    .state 'signup',
        url: '/signup'
        controller: 'loginCtrl'
        title: 'SignUp'
        templateUrl: 'partials/signup.html'

    .state 'check',
        url: '/check/:id'
        controller: 'checkCtrl'
        title: 'check'
        templateUrl: 'partials/check.html'


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
    '$state'
    ($scope, $state) ->
        $scope.test = $state.params.id
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

        $http.get "http://localhost:3000/api/points"
        .success (data) ->
            data.forEach (obj, key) ->
                $http.get "http://localhost:3000/api/points/"+ obj.id
                .success (data) ->
                    obj.coordinates = { latitude: obj.lat, longitude: obj.lng }
                    obj.options = {
                        labelContent: Math.abs(data.energy)
                        labelAnchor: "0 0"
                        labelClass: 'map-label side-' + data.side
                    }
                $scope.points = data

        $scope.map =
            zoom: 15
            center:
                #center on cathedrale
                latitude: 48.5819
                longitude: 7.75104
            options:
                minZoom: 10
                maxZoom: 20
                panControl: false
                zoomControl: true
                mapTypeControl: false
                scaleControl: false
                streetViewControl: false
                overviewMapControl: false
                mapTypeControl: false
]

App.controller 'loginCtrl', [
    '$rootScope'
    '$scope'
    '$state'
    '$http'
    ($rootScope, $scope, $state, $http) ->
        $scope.showTeamPwd = false

        $http.get "http://localhost:3000/api/teams"
        .success (data) ->
            if !data or data.length == 0
                data = [
                    "straliens"
                    "humain"
                ]
            $scope.teams = data

        $scope.onSelect = ($item) ->
            $scope.team = $item
            $scope.showTeamPwd = true

        $scope.validate = (form) ->
            $http.post "http://localhost:3000/api/users",
                nickname: form.mailchimp.FNAME
            .success (data) ->
                $rootScope.user.id = data.id
                $rootScope.user.name = data.nickname
                $rootScope.user.teamId = data.teamId

                $state.go 'play'
            .error (data) ->
                # TODO: make something with the error
                console.log data

        $scope.create = (form) ->
            $http.post "http://localhost:3000/api/users",
                nickname: form.mailchimp.FNAME
                email: form.mailchimp.EMAIL
                password: form.mailchimp.PWD
            .success (data) ->
                $rootScope.user.id = data.id
                $rootScope.user.name = data.nickname
                $rootScope.user.teamId = data.teamId

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
    ($rootScope, $state, $window, $websocket) ->
        $rootScope.$state = $state
        # TODO: récupérer le temps restant
        $rootScope.endTime = '00H00'

        $rootScope.validUser = () ->
            # TODO : check with token/whatever
            return !!$rootScope.user.name

        $rootScope.user =
            team: 'straliens'
            score: 0
            energy: 0

        $rootScope.ws = $websocket "ws://127.0.0.1:8000/ws"
        # $rootScope.ws.send JSON.stringify(action: "test")
]