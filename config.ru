app = proc do |env|
    [200, { "Content-Type" => "text/html" }, ["Now using rack"]]
end
run app