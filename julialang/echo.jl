using Sockets
server = listen(2001)

@async begin  
    while true
        sock = accept(server)
        @async while isopen(sock)
            line = readline(sock, keep=true)
            write(sock, line)
            write(stdout, line)
        end
    end
end

conn = connect(2001)
call(buff::IOBuffer) = @async begin
    write(buff, "\r\n")
    write(conn, take!(buff))
    write(stdout, readline(conn, keep=true))
    println(".........")
end