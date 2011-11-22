module EclipseLaunch
  
  #This module provides the extension for the Builder::Eclipse::Eclipse class.
  module EclipseExtension
    class BasicLauncher

      attr_accessor :project, :vm_args
      
      def initialize(project, options)
        @project = project
        @vm_args = options[:properties].map{|k,v| "-D#{k}=#{v}"}.join(" ")
      end
    end

    class JavaAppLaunch < BasicLauncher

      attr_accessor :main
      
      def initialize(project, options) # :nodoc:
        super(project, options)
        @main = options[:main]
      end

      def write()

        file = project.path_to("#{@project.id}.launch")
        info("Writing #{file}")

        File.open(file, 'w') do |file|
          xml = Builder::XmlMarkup.new(:target=>file, :indent=>2)
          xml.instruct!
          xml.launchConfiguration :type=>"org.eclipse.jdt.launching.localJavaApplication" do

            xml.listAttribute :key=>"org.eclipse.debug.core.MAPPED_RESOURCE_PATHS" do
              xml.listEntry :value=>"/#{project.id}/src/main/java/"
            end

            xml.listAttribute :key=>"org.eclipse.debug.core.MAPPED_RESOURCE_TYPES" do
              xml.listEntry :value=>"1"
            end

            xml.listAttribute :key=>"org.eclipse.debug.ui.favoriteGroups" do
              xml.listEntry :value=>"org.eclipse.debug.ui.launchGroup.debug"
              xml.listEntry :valye=>"org.eclipse.debug.ui.launchGroup.run"
            end

            xml.stringAttribute :key=>"org.eclipse.jdt.launching.MAIN_TYPE", :value=>@main
            xml.stringAttribute :key=>"org.eclipse.jdt.launching.PROJECT_ATTR", :value=>"#{@project.id}"
            xml.stringAttribute :key=>"org.eclipse.jdt.launching.VM_ARGUMENTS", :value=>@vm_args

          end
        end
      end

      def to_s
        "#{self.class}: #{@project.id}->{@main}"
      end

    end

    class TestLaunch < BasicLauncher
      def initialize(project, options)
        super(project, options);
      end

      def to_s
        "#{self.class}: #{@project.id}"
      end

      def write()

        file = project.path_to("#{@project.id}-test.launch")
        info("Writing #{file}")

        File.open(file, 'w') do |file|
          xml = Builder::XmlMarkup.new(:target=>file, :indent=>2)
          xml.instruct!
          xml.launchConfiguration :type=>"org.eclipse.jdt.junit.launchconfig" do
            xml.listAttribute :key=>"org.eclipse.debug.core.MAPPED_RESOURCE_PATHS" do
              xml.listEntry :value=>"/#{@project.id}/"
            end
            xml.listAttribute :key=>"org.eclipse.debug.core.MAPPED_RESOURCE_TYPES" do
              xml.listEntry :value=>"4"
            end
            xml.stringAttribute :key=>"org.eclipse.jdt.junit.CONTAINER", :value=>"=#{@project.id}"
            xml.booleanAttribute :key=>"org.eclipse.jdt.junit.KEEPRUNNING_ATTR", :value=>"false"
            xml.stringAttribute :key=>"org.eclipse.jdt.junit.TESTNAME",  :value=>""
            xml.stringAttribute :key=>"org.eclipse.jdt.junit.TEST_KIND", :value=>"org.eclipse.jdt.junit.loader.junit4"
            xml.stringAttribute :key=>"org.eclipse.jdt.launching.MAIN_TYPE", :value=>""
            xml.stringAttribute :key=>"org.eclipse.jdt.launching.PROJECT_ATTR", :value=>"#{@project.id}"
            xml.stringAttribute :key=>"org.eclipse.jdt.launching.VM_ARGUMENTS", :value=>@vm_args
          end
        end
      end

    end

    attr_accessor :launchers

    def add_launch(project, options)
      if (options.nil? || options[:main].nil?)
        #info("Skipping project #{project.id}.launch (no run configuration)")
        return
      end
      @launchers ||= []
      @launchers += [JavaAppLaunch.new(project, options)]
    end

    private

    def write_launchers()
      @launchers ||= []
      @launchers.each {|l| l.write() }
    end

    def add_project_test(project)
      if(project.test.compile.source.nil?)
        #info("Skipping project #{project.id}-test.launch (no test configuration)")
        return
      end
      @launchers ||= []
      @launchers += [TestLaunch.new(project, project.test.options)]
    end

    def add_project_run(project)
      add_launch(project, project.run.options)
    end
  end

  #This module adds the default .launch files for each project (run & test)
  module Register

    include Extension

    first_time do

    end

    before_define do |project|
    end

    after_define(:eclipse=>:run) do |project|
      
      #setup the default launchers
      project.eclipse.send(:add_project_test,project)
      project.eclipse.send(:add_project_run,project)

      #enchance the eclipse task to also write the .launch files
      project.task('eclipse').enhance do |task|
        project.eclipse.send(:write_launchers)
      end
    end
  end
end

#Eclipse class enhancement with new features
class Buildr::Eclipse::Eclipse
  include EclipseLaunch::EclipseExtension
end

#Enhancement of Project with (run & test) default .launch generation
class Buildr::Project
  include EclipseLaunch::Register
end
