timeTracker.controller 'OptionCtrl', ($scope, $redmine, $account, $message) ->

  $scope.option = { apiKey:'', id:'', pass:'', url:'' }
  $scope.authWay = 'id_pass'
  $scope.isSaving = false


  ###
   Initialize Option page.
  ###
  init = ->
    # restore accounts
    $account.getAccounts (accounts) ->
      if not accounts? or not accounts[0]? then return
      $scope.option.url    = accounts[0].url
      $scope.option.apiKey = accounts[0].apiKey
      $scope.option.id     = accounts[0].id
      $scope.option.pass   = accounts[0].pass


  ###
   Load the user ID associated to Api Key.
  ###
  $scope.saveOptions = () ->
    $scope.isSaving = true
    if not $scope.option.url? or $scope.option.url.length is 0
      $message.toast "Please input Redmine Server URL."
      return
    $scope.option.url = util.getUrl $scope.option.url
    $redmine($scope.option).user.get(saveSucess, saveFail)


  ###
   sucess to save
  ###
  saveSucess = (msg) ->
    $scope.isSaving = false
    if msg?.user?.id?
      account =
        url:    $scope.option.url
        apiKey: $scope.option.apiKey
        id:     $scope.option.id
        pass:   $scope.option.pass
        userId: msg.user.id
      $account.addAccount account, (result) ->
        if result
          $message.toast "Succeed accessing to the server!"
          $scope.$emit 'notifyAccountChanged'
        else
          saveFail null
    else
      saveFail msg


  ###
   fail to save
  ###
  saveFail = (msg) ->
    $scope.isSaving = false
    $message.toast "Save Failed. #{msg}"


  ###
   clear all account data.
  ###
  $scope.clearOptions = () ->
    $account.clearAccount (result) ->
      if result
        $message.toast "All data Cleared."
      else
        $message.toast "Clear Failed."


  ###
   Initialize
  ###
  init()
