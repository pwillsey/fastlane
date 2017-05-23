describe Scan do
  describe Scan::ReportCollector do
    let (:path) { "./scan/spec/fixtures/boring.log" }

    it "ignores invalid report types" do
      commands = Scan::ReportCollector.new(false, false, "invalid, html", "/tmp", false).generate_commands(path)

      expect(commands.count).to eq(1)
      expect(commands).to eq({
                                 "/tmp/report.html" => "cat './scan/spec/fixtures/boring.log' |  xcpretty --report html --output '/tmp/report.html' &> /dev/null "
                             })
    end

    it "names the json compilation database with the correct name when the json_compilation_database_clang option is set" do
      commands = Scan::ReportCollector.new(false, false, "json-compilation-database", "/tmp", true).generate_commands(path)

      expect(commands.count).to eq(1)
      expect(commands).to eq({
                                 "/tmp/compile_commands.json" => "cat './scan/spec/fixtures/boring.log' |  xcpretty --report json-compilation-database --output '/tmp/compile_commands.json' &> /dev/null "
                             })
    end

    it "names the json compilation database with the correct name when the json_compilation_database_clang option is not set" do
      commands = Scan::ReportCollector.new(false, false, "json-compilation-database", "/tmp", false).generate_commands(path)

      expect(commands.count).to eq(1)
      expect(commands).to eq({
                                 "/tmp/report.json-compilation-database" => "cat './scan/spec/fixtures/boring.log' |  xcpretty --report json-compilation-database --output '/tmp/report.json-compilation-database' &> /dev/null "
                              })
    end

    it "includes screenshot parameter if specified by user" do
      commands = Scan::ReportCollector.new(false, true, "html", "/tmp", false).generate_commands(path)

      expect(commands.count).to eq(1)
      expect(commands).to eq({
                                 "/tmp/report.html" => "cat './scan/spec/fixtures/boring.log' |  xcpretty --report html --output '/tmp/report.html' --screenshots &> /dev/null "
                             })
    end
  end
end
