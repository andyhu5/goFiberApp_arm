# 设置环境变量
export GOOS=linux
export GOARCH=arm64
export CC=aarch64-linux-gnu-gcc


# 进行编译
# go build -ldflags '-extldflags "-static"' main.go
go build

ssh openailab@192.168.3.173 'killall goFiber && echo "killall goFiber success"'
scp goFiber openailab@192.168.3.173:~/app/goFiber && echo "scp goFiber success"
ssh openailab@192.168.3.173 '~/app/goFiber &' &
