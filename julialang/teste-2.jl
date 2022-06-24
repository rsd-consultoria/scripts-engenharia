function paralelo()
f = open("teste.txt", "w")
write(f,"\n\r12323423")
flush(f)
close(f)

g = open("teste.txt", "r")
for a in readlines(g)
   println(a)
end
close(g)
end


task = @async paralelo()
wait(task)


mutable struct Money
   amount::UInt16
   currency::String
end

function money2number(T::Type, money::Money)::Number
   return T(money.amount / 1000)
end

function number2money(value::Number):Money
   return Money(UInt16(round(value, digits=3) * 1000), "BRL")
end

function number2money(value::Number, money::Money)::Money
   money.amount = UInt16(round(value, digits=3) * 1000)
   return money
end


@show money2number(Float16, Money(12340, "BRL"))
@show a = number2money(50/3)

@show round(money2number(Float16, a) * 3, digits=2)
number2money(50/3, a)

@show round((a.amount * 3) / 1000, digits=2)
@show typeof(money2number(Float32, a))

using Sockets
errormonitor(@async begin
                  server = listen(ip"192.168.100.7", 2001)
                  while true
                      sock = accept(server)
                      @async while isopen(sock)
                          data = readline(sock, keep=true)
			  println(stdout, data)
                          write(sock, data)
                      end
                  end
              end)
readline()
