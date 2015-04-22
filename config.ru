app = proc do |env|
    [200, { "Content-Type" => "text/html" }, ["No on rack"]]
end
run app