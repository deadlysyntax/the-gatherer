app = proc do |env|
    [200, { "Content-Type" => "text/html" }, ["Restarting automatically"]]
end
run app