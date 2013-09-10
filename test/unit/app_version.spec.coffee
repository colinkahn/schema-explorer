describe "App Version Directive", ->
  # Initialize these values up here
  scope    = null
  $compile = null

  beforeEach module "APP"
  beforeEach module "partials/app_version.html"

  beforeEach inject ($rootScope, _$compile_) ->
    $compile = _$compile_
    scope    = $rootScope.$new()

  describe "Structure", ->
    element  = null
    template = """
      <app-version></app-version>
    """

    beforeEach ->
      element = $compile(template)(scope)
      scope.$apply()

    it "should have an id of 'version'", ->
      expect(element.attr("id")).toBe "version"

    it "should contain a version number", ->
      expect(element.html()).toMatch /v\d+.\d+.\d+/


