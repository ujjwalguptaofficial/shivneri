const { exec, ChildProcessWithoutNullStreams, spawn } = require("child_process");

class CommandRunner {
    // cmdString: string
    //   childProcess_: ChildProcessWithoutNullStreams
    //   onResolve_;
    //   onReject_;


    constructor(cmd) {
        this.cmdString = cmd;
        // this.event = new EventEmitter();
    }

    run() {
        return new Promise((res, rej) => {
            this.onResolve_ = res;
            this.onReject_ = rej;
            this.childProcess_ = spawn(this.cmdString, {
                detached: true,
                stdio: 'pipe',
                shell: true
            });
            //exec(this.cmdString);
            this.childProcess_.stdout.on('data', (data) => {
                console.log("data", data.toString())
            });
            this.childProcess_.stderr.on('data', (data) => {
                console.log("error", data.toString())
            });
            this.childProcess_.on("error", (err) => {
                rej(err);
            })
            this.childProcess_.on('exit', (code) => {
                res(code);
            });
        })
    }



    async quit() {
        process.kill(-this.childProcess_.pid);
    }

}


new CommandRunner("cd tests/general && CRYSTAL_ENV=TEST crystal spec e2e/* --error-trace").run();