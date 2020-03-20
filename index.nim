import os
import asynchttpserver, asyncdispatch
var server = newAsyncHttpServer()
import parseutils
import strutils
import parseopt
import terminal

stdout.styledWrite(fgBlue, "CandyScript is ready to show off\n")
var sample = ""
for kind, key, val in getOpt():
  case kind
  of cmdArgument:
    stdout.styledWrite(fgYellow, "[START] ")
    stdout.styledWrite(fgDefault, key&"\n")
    sample = readFile(key)
  of cmdLongOption, cmdShortOption:
    echo "flags not needed"
  of cmdEnd: discard

var get_list: seq[seq[string]] = @[]
var post_list: seq[seq[string]] = @[]
var port = "8080"

proc cb(req: Request) {.async, gcsafe.} =
  echo("\u001b[32m",req.reqMethod,"\u001b[0m"," ", req.url.path)
  if req.url.path.startsWith("/public") and req.reqMethod == HttpGet:
    var staticFile = readFile(joinPath(getCurrentDir(),"./public"&req.url.path.split("/public")[1]))
    await req.respond(Http200, staticFile)
  for state in get_list:
    if req.url.path == state[1].split(" ").join() and req.reqMethod == HttpGet:
      #[ TODO: use nimpy to do this
      if(state[3] == "python"):
        var glob = pyBuiltinsModule()
        let pfn = glob.eval(state[2]).to(string)
        await req.respond(Http200, pfn)
        ]#
      await req.respond(Http200, state[2])
    if req.url.path == state[1].split(" ").join() and req.reqMethod == HttpPost:
      await req.respond(Http200, state[2])

proc createServer() =
  stdout.styledWrite(fgYellow, "[START] ")
  stdout.styledWrite(fgDefault, "Listening to requests on port: ")
  stdout.styledWrite(fgDefault, port&"\n")
  waitFor server.serve(Port(port.parseInt()), cb)

proc parseToken(tk, url, arg: string) =
  var title = url
  var excp: string = ""
  var tok = tk.unindent.split(" ").join()
  var arg = arg.unindent.split(" ").join()
  if arg.split(":")[0].split(" ").join() == "file":
    arg = readFile(arg.split(":")[1].split(" ").join())
  if arg.split(":")[0].split(" ").join() == "python":
    # TODO: Add python bindings
    arg = arg.split(":")[1].split("{").join().split("}").join()
    excp = "python"
  case tok:
  of "GET", "get":
    get_list.add(@["GET", title, arg, excp])
  of "POST", "post":
    post_list.add(@["POST", title, arg, excp])
  of "SET", "set":
    case title
      of "port", "PORT":
        port = arg
  of "", " ", "#":
    discard

proc parse(line: string) =
  var i = 0
  var domainCode = ""
  var useless = ""
  i.inc parseUntil(line, domainCode, {'"'}, i)
  i.inc
  var pageTitle = ""
  i.inc parseUntil(line, pageTitle, {'"'}, i)
  i.inc
  i.inc parseUntil(line, useless, {':'}, i)
  i.inc
  var arg = ""
  i.inc parseUntil(line, arg, {'\n'}, i)
  i.inc
  parseToken(domainCode, pageTitle, arg)

for x in sample.split('\n'):
  parse(x)

createServer()

