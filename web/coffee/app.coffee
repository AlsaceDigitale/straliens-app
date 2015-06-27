@App = angular.module 'straliens', ['ui.router', 'uiGmapgoogle-maps', 'ngWebSocket', 'ui.bootstrap']
App.config (uiGmapGoogleMapApiProvider) ->
    uiGmapGoogleMapApiProvider.configure {
        # key: 'your api key'
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
                    color = if data.side == "STRALIENS" then '#0AAE14' else '#238CFF'
                    obj.coordinates = { latitude: obj.lat, longitude: obj.lng }
                    obj.options = {
                        labelContent: data.energy
                        labelAnchor: "2 -8"
                        labelClass: 'map-label'
                        labelStyle: {color: color}
                    }
                    obj.icon =
                        #circle
                        path: 'M 100, 100
                                    m -75, 0
                                    a 75,75 0 1,0 150,0
                                    a 75,75 0 1,0 -150,0'
                        fillOpacity: 0.15
                        scale: 0.18
                        strokeColor: color
                        strokeWeight: 6
                        strokeOpacity: 0.9
                $scope.points = data

        $scope.map =
            zoom: 15
            center:
                latitude: 48.5803
                longitude: 7.7536
            options:
                minZoom: 15
                maxZoom: 20
                #mapTypeId: "satellite"
                streetViewControl: false

            events:
                center_changed: (map) ->
                    allowedBounds =
                        sw: [48.575617, 7.732757]
                        ne: [48.585780, 7.775462]
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

        #uiGmapGoogleMapApi.then (maps) ->
]

App.controller 'loginCtrl', [
    '$rootScope'
    '$scope'
    '$state'
    '$http'
    ($rootScope, $scope, $state, $http) ->
        $scope.teams = $http.get "http://localhost:3000/api/teams"
          .success (data) ->
            data

        $scope.validate = (form) ->
            $http.post "http://localhost:3000/api/users", nickname: form.mailchimp.FNAME
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

        $rootScope.ws = $websocket("ws://127.0.0.1:3000/ws");
        # $rootScope.ws.send JSON.stringify(action: "test")
]
