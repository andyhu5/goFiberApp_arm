pc:
	@echo "Deploy to PC Server!"

	# 进行编译
	GOOS=windows GOARCH=amd64 go build -o goFiber.exe main.go
	# 进行压缩
	upx -9 goFiber.exe
	sleep 2

	ssh sheng@192.168.2.18 'taskkill /F /IM goFiber.exe'
	ssh sheng@192.168.2.18 'Remove-Item app/goFiber.exe -Force'

	# ssh sheng@192.168.2.18 'Set-NetFirewallProfile -All -Enabled False'

	scp goFiber.exe sheng@192.168.2.18:app/goFiber.exe
	ssh sheng@192.168.2.18 'app/goFiber.exe'

arm:
	@echo "Deploying to ARM64"
	# 进行编译
	CC=aarch64-linux-gnu-gcc GOOS=linux GOARCH=arm64 go build -ldflags '-extldflags "-static"' -o goFiber main.go
	sleep 3
	ssh openailab@192.168.3.173 'killall goFiber'
	scp goFiber openailab@192.168.3.173:~/app/goFiber && echo "scp goFiber success"
	ssh openailab@192.168.3.173 '~/app/goFiber &' &

clean:
	rm -rf goFiber.exe
	rm -rf goFiber

test_pc:

	@for i in $$(seq 1 10000); do \
		echo -n $$i && echo -n " " && curl 192.168.2.18:9000; \
	done

test_arm:

	@for i in $$(seq 1 10000); do \
		echo -n $$i && echo -n " " && curl 192.168.3.173:9000; \
	done