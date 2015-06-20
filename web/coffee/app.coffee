@App = angular.module 'straliens', ['ui.router', 'uiGmapgoogle-maps']

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
            title: 'Accueil'
            templateUrl: 'partials/login.html'

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
    '$state'
    'uiGmapGoogleMapApi'
    ($rootScope, $scope, $state, uiGmapGoogleMapApi) ->
        if !$rootScope.validUser()
            $state.go 'login'

        $scope.points =
        [
            {
                id: 1
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.5870549
                    longitude: 7.7464128
            }
            {
                id: 2
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.5818526
                    longitude: 7.751036899999999
            }
            {
                id: 3
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.5827682
                    longitude: 7.7410269000000005
            }
            {
                id: 4
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.5832224
                    longitude: 7.7533864999999995
            }
            {
                id: 5
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.5855787
                    longitude: 7.7477646
            }
            {
                id: 6
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.5849542
                    longitude: 7.741670600000001
            }
            {
                id: 7
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.581519
                    longitude: 7.743558900000001
            }
            {
                id: 8
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.5835631
                    longitude: 7.7489877
            }
            {
                id: 9
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.5837334
                    longitude: 7.744245599999999
            }
            {
                id: 10
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.5819165
                    longitude: 7.747678799999999
            }
            {
                id: 11
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.5834353
                    longitude: 7.7457047
            }
            {
                id: 12
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.5804969
                    longitude: 7.7499533
            }
            {
                id: 13
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.5859194
                    longitude: 7.750897400000001
            }
            {
                id: 14
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.580610500000006
                    longitude: 7.743344300000001
            }
            {
                id: 15
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.5818313
                    longitude: 7.754716900000001
            }
            {
                id: 16
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.5812351
                    longitude: 7.7405548
            }
            {
                id: 17
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.5798723
                    longitude: 7.7444172
            }
            {
                id: 18
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.579418
                    longitude: 7.7468634
            }
            {
                id: 19
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.5847554
                    longitude: 7.73592
            }
            {
                id: 20
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.58526640000001
                    longitude: 7.752742799999999
            }
            {
                id: 21
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.58407410000001
                    longitude: 7.7501249
            }
            {
                id: 22
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.5846135
                    longitude: 7.7459192
            }
            {
                id: 23
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.58526640000001
                    longitude: 7.754631000000001
            }
            {
                id: 24
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.5847838
                    longitude: 7.7615404
            }
            {
                id: 25
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.5793328
                    longitude: 7.7588367
            }
            {
                id: 26
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.5784527
                    longitude: 7.755918500000001
            }
            {
                id: 27
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.5783675
                    longitude: 7.7617979
            }
            {
                id: 28
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.5788218
                    longitude: 7.751240700000001
            }
            {
                id: 29
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.5810363
                    longitude: 7.760381700000001
            }
            {
                id: 30
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.5871401
                    longitude: 7.7538156
            }
            {
                id: 31
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.5833643
                    longitude: 7.7589226
            }
            {
                id: 32
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.581377
                    longitude: 7.758150100000001
            }
            {
                id: 33
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.5821436
                    longitude: 7.759823800000001
            }
            {
                id: 34
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.5802698
                    longitude: 7.756948500000001
            }
            {
                id: 35
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.5813699
                    longitude: 7.7621305
            }
            {
                id: 36
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.5791909
                    longitude: 7.761207800000001
            }
            {
                id: 37
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.578907
                    longitude: 7.7664328
            }
            {
                id: 38
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.5768059
                    longitude: 7.756991400000001
            }
            {
                id: 39
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.57439240000001
                    longitude: 7.7589226
            }
            {
                id: 40
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.5738245
                    longitude: 7.7652311
            }
            {
                id: 41
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.5839321
                    longitude: 7.765273999999999
            }
            {
                id: 42
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.5841309
                    longitude: 7.739718
            }
            {
                id: 43
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.5807382
                    longitude: 7.7412629
            }
            {
                id: 44
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.580113600000004
                    longitude: 7.742421600000001
            }
            {
                id: 45
                name: ''
                description: 'test'
                coordinates:
                    latitude: 48.5825552
                    longitude: 7.7458549
            }
        ]

        $scope.points.forEach (obj, key) ->
            obj.team = if Math.random() > 0.5 then "straliens" else "terriens"
            obj.power = Math.round (Math.random() * 100)
            color = if obj.team == "straliens" then '#0AAE14' else '#238CFF'
            obj.options = {
                labelContent: obj.power
                labelAnchor: "2 -8"
                labelClass: 'map-label'
                labelStyle: {color: color}
            }
            obj.icon =
                path: 'M 100, 100
                            m -75, 0
                            a 75,75 0 1,0 150,0
                            a 75,75 0 1,0 -150,0'
                fillOpacity: 0.15
                scale: 0.18
                strokeColor: color
                strokeWeight: 6
                strokeOpacity: 0.9

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
]

# RUN !!
# ------
App.run [
    '$rootScope'
    '$state'
    ($rootScope, $state) ->
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
]
