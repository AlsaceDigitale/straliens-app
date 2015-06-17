@App = angular.module 'straliens', ['ui.router', 'ngMap']

App.config [ -> ]

App.config ($stateProvider, $urlRouterProvider) ->
    $urlRouterProvider.otherwise '/play'

    $stateProvider
        .state 'login',
            url: '/login'
            controller: 'loginCtrl'
            title: 'Accueil'
            templateUrl: 'partials/login.html'

        .state 'play',
            url: '/play'
            controller: 'playCtrl'
            title: 'Accueil'
            templateUrl: 'partials/play.html'


# Main controller
# ---------------
App.controller 'AppController', [
    '$scope'
    ($scope) ->
]

# Index page controller
# ---------------------
App.controller 'playCtrl', [
    '$scope'
    '$state'
    ($scope, $state) ->
        $scope.$on 'mapInitialized', (event, map) ->

        $scope.points = [
            {
                "name":"",
                "description":"test",
                "coordinates": [48.5870549, 7.7464128]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.5818526, 7.751036899999999]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.5827682, 7.7410269000000005]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.5832224, 7.7533864999999995]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.5855787, 7.7477646]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.5849542, 7.741670600000001]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.581519, 7.743558900000001]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.5835631, 7.7489877]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.5837334, 7.744245599999999]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.5819165, 7.747678799999999]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.5834353, 7.7457047]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.5804969, 7.7499533]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.5859194, 7.750897400000001]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.580610500000006, 7.743344300000001]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.5818313, 7.754716900000001]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.5812351, 7.7405548]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.5798723, 7.7444172]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.579418, 7.7468634]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.5847554, 7.73592]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.58526640000001, 7.752742799999999]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.58407410000001, 7.7501249]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.5846135, 7.7459192]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.58526640000001, 7.754631000000001]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.5847838, 7.7615404]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.5793328, 7.7588367]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.5784527, 7.755918500000001]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.5783675, 7.7617979]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.5788218, 7.751240700000001]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.5810363, 7.760381700000001]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.5871401, 7.7538156]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.5833643, 7.7589226]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.581377, 7.758150100000001]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.5821436, 7.759823800000001]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.5802698, 7.756948500000001]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.5813699, 7.7621305]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.5791909, 7.761207800000001]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.578907, 7.7664328]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.5768059, 7.756991400000001]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.57439240000001, 7.7589226]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.5738245, 7.7652311]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.5839321, 7.765273999999999]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.5841309, 7.739718]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.5807382, 7.7412629]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.580113600000004, 7.742421600000001]
            },
            {
                "name":"",
                "description":"test",
                "coordinates": [48.5825552, 7.7458549]
            }
        ]


        allowedBounds =
            sw: [48.575617, 7.732757]
            ne: [48.585780, 7.775462]

        $scope.test = ->
            C = this.getCenter()
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

                this.panTo {lat: Y, lng: X}

        $scope.events =
            drag:(event, map) ->
                console.log event, map

        $scope.map =
            center:
                latitude: 48.5803
                longitude: 7.7536
            zoom: 15
]

App.controller 'loginCtrl', [
    '$scope'
    '$state'
    ($scope, $state) ->
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
        $rootScope.user =
            team: 'straliens'
            score: 0
            energy: 0
]
