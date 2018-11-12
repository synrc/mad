function clean(r)      { for(var k in r) if(!r[k]) delete r[k]; return r; }
function check_len(x)  { try { return (eval('len'+utf8_dec(x.v[0].v))() == x.v.length) ? true : false }
                         catch (e) { return false; } }

function scalar(data)    {
    var res = undefined;
    switch (typeof data) {
        case 'string': res = bin(data); break; case 'number': res = number(data); break;
        default: console.log('Strange data: ' + data); }
    return res; };
function nil() { return {t: 106, v: undefined}; };

function decode(x) {
    if (x == undefined) {
        return [];
    } if (x % 1 === 0) {
        return x;
    } else if (x.t == 108) {
        var r = []; x.v.forEach(function(y) { r.push(decode(y)) }); return r;
    } else if (x.t == 109) {
        return utf8_dec(x.v);
    } else if (x.t == 104 && check_len(x)) {
        return eval('dec'+x.v[0].v)(x);
    } else if (x.t == 104) {
        var r=[]; x.v.forEach(function(a){r.push(decode(a))});
	return Object.assign({tup:'$'}, r);
    } else return x.v;
}

function encode(x) {
    if (Array.isArray(x)) {
        var r = []; x.forEach(function(y) { r.push(encode(y)) }); return {t:108,v:r};
    } else if (typeof x == 'object') {
        switch (x.tup) {
	case '$': delete x['tup']; var r=[];
    Object.keys(x).map(function(p){return x[p];}).forEach(function(a){r.push(encode(a))});
	return {t:104, v:r};
	default: return eval('enc'+x.tup)(x); }
    } else return scalar(x);
}

function encwriter(d) {
    var tup = atom('writer');
    var id = 'id' in d && d.id ? encode(d.id) : nil();
    var count = 'count' in d && d.count ? number(d.count) : nil();
    var cache = 'cache' in d && d.cache ? encode(d.cache) : nil();
    var args = 'args' in d && d.args ? encode(d.args) : nil();
    var first = 'first' in d && d.first ? encode(d.first) : nil();
    return tuple(tup,id,count,cache,args,first); }

function lenwriter() { return 6; }
function decwriter(d) {
    var r={}; r.tup = 'writer';
    r.id = d && d.v[1] ? decode(d.v[1].v) : undefined;
    r.count = d && d.v[2] ? d.v[2].v : undefined;
    r.cache = d && d.v[3] ? decode(d.v[3].v) : undefined;
    r.args = d && d.v[4] ? decode(d.v[4].v) : undefined;
    r.first = d && d.v[5] ? decode(d.v[5].v) : undefined;
    return clean(r); }

function encreader(d) {
    var tup = atom('reader');
    var id = 'id' in d && d.id ? encode(d.id) : nil();
    var pos = 'pos' in d && d.pos ? number(d.pos) : nil();
    var cache = 'cache' in d && d.cache ? number(d.cache) : nil();
    var args = 'args' in d && d.args ? encode(d.args) : nil();
    var feed = 'feed' in d && d.feed ? encode(d.feed) : nil();
    var dir = 'dir' in d && d.dir ? encode(d.dir) : nil();
    return tuple(tup,id,pos,cache,args,feed,dir); }

function lenreader() { return 7; }
function decreader(d) {
    var r={}; r.tup = 'reader';
    r.id = d && d.v[1] ? decode(d.v[1].v) : undefined;
    r.pos = d && d.v[2] ? d.v[2].v : undefined;
    r.cache = d && d.v[3] ? d.v[3].v : undefined;
    r.args = d && d.v[4] ? decode(d.v[4].v) : undefined;
    r.feed = d && d.v[5] ? decode(d.v[5].v) : undefined;
    r.dir = d && d.v[6] ? decode(d.v[6]) : undefined;
    return clean(r); }

function enccur(d) {
    var tup = atom('cur');
    var id = 'id' in d && d.id ? encode(d.id) : nil();
    var top = 'top' in d && d.top ? number(d.top) : nil();
    var bot = 'bot' in d && d.bot ? number(d.bot) : nil();
    var dir = 'dir' in d && d.dir ? encode(d.dir) : nil();
    var reader = 'reader' in d && d.reader ? encode(d.reader) : nil();
    var writer = 'writer' in d && d.writer ? encode(d.writer) : nil();
    var args = []; if ('args' in d && d.args)
	 { d.args.forEach(function(x){
	args.push(encode(x))});
	 args={t:108,v:args}; } else { args = nil() };
    return tuple(tup,id,top,bot,dir,reader,writer,args); }

function lencur() { return 8; }
function deccur(d) {
    var r={}; r.tup = 'cur';
    r.id = d && d.v[1] ? decode(d.v[1].v) : undefined;
    r.top = d && d.v[2] ? d.v[2].v : undefined;
    r.bot = d && d.v[3] ? d.v[3].v : undefined;
    r.dir = d && d.v[4] ? decode(d.v[4]) : undefined;
    r.reader = d && d.v[5] ? decode(d.v[5].v) : undefined;
    r.writer = d && d.v[6] ? decode(d.v[6].v) : undefined;
    r.args = [];
	 (d && d.v[7] && d.v[7].v) ?
	 d.v[7].v.forEach(function(x){r.args.push(decode(x))}) :
	 r.args = undefined;
    return clean(r); }

function enciter(d) {
    var tup = atom('iter');
    var id = 'id' in d && d.id ? number(d.id) : nil();
    var container = 'container' in d && d.container ? atom(d.container) : nil();
    var feed = 'feed' in d && d.feed ? encode(d.feed) : nil();
    var next = 'next' in d && d.next ? number(d.next) : nil();
    var prev = 'prev' in d && d.prev ? number(d.prev) : nil();
    return tuple(tup,id,container,feed,next,prev); }

function leniter() { return 6; }
function deciter(d) {
    var r={}; r.tup = 'iter';
    r.id = d && d.v[1] ? d.v[1].v : undefined;
    r.container = d && d.v[2] ? d.v[2].v : undefined;
    r.feed = d && d.v[3] ? decode(d.v[3].v) : undefined;
    r.next = d && d.v[4] ? d.v[4].v : undefined;
    r.prev = d && d.v[5] ? d.v[5].v : undefined;
    return clean(r); }

function enccontainer(d) {
    var tup = atom('container');
    var id = 'id' in d && d.id ? number(d.id) : nil();
    var top = 'top' in d && d.top ? number(d.top) : nil();
    var rear = 'rear' in d && d.rear ? number(d.rear) : nil();
    var count = 'count' in d && d.count ? number(d.count) : nil();
    return tuple(tup,id,top,rear,count); }

function lencontainer() { return 5; }
function deccontainer(d) {
    var r={}; r.tup = 'container';
    r.id = d && d.v[1] ? d.v[1].v : undefined;
    r.top = d && d.v[2] ? d.v[2].v : undefined;
    r.rear = d && d.v[3] ? d.v[3].v : undefined;
    r.count = d && d.v[4] ? d.v[4].v : undefined;
    return clean(r); }

function enciterator(d) {
    var tup = atom('iterator');
    var id = 'id' in d && d.id ? number(d.id) : nil();
    var container = 'container' in d && d.container ? atom(d.container) : nil();
    var feed_id = 'feed_id' in d && d.feed_id ? encode(d.feed_id) : nil();
    var prev = 'prev' in d && d.prev ? number(d.prev) : nil();
    var next = 'next' in d && d.next ? number(d.next) : nil();
    var feeds = []; if ('feeds' in d && d.feeds)
	 { d.feeds.forEach(function(x){
	feeds.push(encode(x))});
	 feeds={t:108,v:feeds}; } else { feeds = nil() };
    return tuple(tup,id,container,feed_id,prev,next,feeds); }

function leniterator() { return 7; }
function deciterator(d) {
    var r={}; r.tup = 'iterator';
    r.id = d && d.v[1] ? d.v[1].v : undefined;
    r.container = d && d.v[2] ? d.v[2].v : undefined;
    r.feed_id = d && d.v[3] ? decode(d.v[3].v) : undefined;
    r.prev = d && d.v[4] ? d.v[4].v : undefined;
    r.next = d && d.v[5] ? d.v[5].v : undefined;
    r.feeds = [];
	 (d && d.v[6] && d.v[6].v) ?
	 d.v[6].v.forEach(function(x){r.feeds.push(decode(x))}) :
	 r.feeds = undefined;
    return clean(r); }

function enclog(d) {
    var tup = atom('log');
    var id = 'id' in d && d.id ? number(d.id) : nil();
    var top = 'top' in d && d.top ? number(d.top) : nil();
    var rear = 'rear' in d && d.rear ? number(d.rear) : nil();
    var count = 'count' in d && d.count ? number(d.count) : nil();
    return tuple(tup,id,top,rear,count); }

function lenlog() { return 5; }
function declog(d) {
    var r={}; r.tup = 'log';
    r.id = d && d.v[1] ? d.v[1].v : undefined;
    r.top = d && d.v[2] ? d.v[2].v : undefined;
    r.rear = d && d.v[3] ? d.v[3].v : undefined;
    r.count = d && d.v[4] ? d.v[4].v : undefined;
    return clean(r); }

function encoperation(d) {
    var tup = atom('operation');
    var id = 'id' in d && d.id ? number(d.id) : nil();
    var container = 'container' in d && d.container ? atom(d.container) : nil();
    var feed_id = 'feed_id' in d && d.feed_id ? encode(d.feed_id) : nil();
    var prev = 'prev' in d && d.prev ? number(d.prev) : nil();
    var next = 'next' in d && d.next ? number(d.next) : nil();
    var feeds = []; if ('feeds' in d && d.feeds)
	 { d.feeds.forEach(function(x){
	feeds.push(encode(x))});
	 feeds={t:108,v:feeds}; } else { feeds = nil() };
    return tuple(tup,id,container,feed_id,prev,next,feeds); }

function lenoperation() { return 7; }
function decoperation(d) {
    var r={}; r.tup = 'operation';
    r.id = d && d.v[1] ? d.v[1].v : undefined;
    r.container = d && d.v[2] ? d.v[2].v : undefined;
    r.feed_id = d && d.v[3] ? decode(d.v[3].v) : undefined;
    r.prev = d && d.v[4] ? d.v[4].v : undefined;
    r.next = d && d.v[5] ? d.v[5].v : undefined;
    r.feeds = [];
	 (d && d.v[6] && d.v[6].v) ?
	 d.v[6].v.forEach(function(x){r.feeds.push(decode(x))}) :
	 r.feeds = undefined;
    return clean(r); }

function encfeed(d) {
    var tup = atom('feed');
    var id = 'id' in d && d.id ? number(d.id) : nil();
    var top = 'top' in d && d.top ? number(d.top) : nil();
    var rear = 'rear' in d && d.rear ? number(d.rear) : nil();
    var count = 'count' in d && d.count ? number(d.count) : nil();
    return tuple(tup,id,top,rear,count); }

function lenfeed() { return 5; }
function decfeed(d) {
    var r={}; r.tup = 'feed';
    r.id = d && d.v[1] ? d.v[1].v : undefined;
    r.top = d && d.v[2] ? d.v[2].v : undefined;
    r.rear = d && d.v[3] ? d.v[3].v : undefined;
    r.count = d && d.v[4] ? d.v[4].v : undefined;
    return clean(r); }

function encmax_tour(d) {
    var tup = atom('max_tour');
    var count = 'count' in d && d.count ? number(d.count) : nil();
    var joined = 'joined' in d && d.joined ? number(d.joined) : nil();
    return tuple(tup,count,joined); }

function lenmax_tour() { return 3; }
function decmax_tour(d) {
    var r={}; r.tup = 'max_tour';
    r.count = d && d.v[1] ? d.v[1].v : undefined;
    r.joined = d && d.v[2] ? d.v[2].v : undefined;
    return clean(r); }

function encjoin_application(d) {
    var tup = atom('join_application');
    var id = 'id' in d && d.id ? number(d.id) : nil();
    var name = 'name' in d && d.name ? bin(d.name) : nil();
    var data = 'data' in d && d.data ? encode(d.data) : nil();
    return tuple(tup,id,name,data); }

function lenjoin_application() { return 4; }
function decjoin_application(d) {
    var r={}; r.tup = 'join_application';
    r.id = d && d.v[1] ? d.v[1].v : undefined;
    r.name = d && d.v[2] ? utf8_dec(d.v[2].v) : undefined;
    r.data = d && d.v[3] ? decode(d.v[3].v) : undefined;
    return clean(r); }

function enctour_list(d) {
    var tup = atom('tour_list');
    var users = []; if ('users' in d && d.users)
	 { d.users.forEach(function(x){
	users.push(encode(x))});
	 users={t:108,v:users}; } else { users = nil() };
    return tuple(tup,users); }

function lentour_list() { return 2; }
function dectour_list(d) {
    var r={}; r.tup = 'tour_list';
    r.users = [];
	 (d && d.v[1] && d.v[1].v) ?
	 d.v[1].v.forEach(function(x){r.users.push(decode(x))}) :
	 r.users = undefined;
    return clean(r); }

function enctask(d) {
    var tup = atom('task');
    var name = 'name' in d && d.name ? atom(d.name) : nil();
    var roles = 'roles' in d && d.roles ? bin(d.roles) : nil();
    var module = 'module' in d && d.module ? atom(d.module) : nil();
    return tuple(tup,name,roles,module); }

function lentask() { return 4; }
function dectask(d) {
    var r={}; r.tup = 'task';
    r.name = d && d.v[1] ? d.v[1].v : undefined;
    r.roles = d && d.v[2] ? utf8_dec(d.v[2].v) : undefined;
    r.module = d && d.v[3] ? d.v[3].v : undefined;
    return clean(r); }

function encuserTask(d) {
    var tup = atom('userTask');
    var name = 'name' in d && d.name ? atom(d.name) : nil();
    var roles = 'roles' in d && d.roles ? bin(d.roles) : nil();
    var module = 'module' in d && d.module ? atom(d.module) : nil();
    return tuple(tup,name,roles,module); }

function lenuserTask() { return 4; }
function decuserTask(d) {
    var r={}; r.tup = 'userTask';
    r.name = d && d.v[1] ? d.v[1].v : undefined;
    r.roles = d && d.v[2] ? utf8_dec(d.v[2].v) : undefined;
    r.module = d && d.v[3] ? d.v[3].v : undefined;
    return clean(r); }

function encserviceTask(d) {
    var tup = atom('serviceTask');
    var name = 'name' in d && d.name ? atom(d.name) : nil();
    var roles = 'roles' in d && d.roles ? bin(d.roles) : nil();
    var module = 'module' in d && d.module ? atom(d.module) : nil();
    return tuple(tup,name,roles,module); }

function lenserviceTask() { return 4; }
function decserviceTask(d) {
    var r={}; r.tup = 'serviceTask';
    r.name = d && d.v[1] ? d.v[1].v : undefined;
    r.roles = d && d.v[2] ? utf8_dec(d.v[2].v) : undefined;
    r.module = d && d.v[3] ? d.v[3].v : undefined;
    return clean(r); }

function encreceiveTask(d) {
    var tup = atom('receiveTask');
    var name = 'name' in d && d.name ? atom(d.name) : nil();
    var roles = 'roles' in d && d.roles ? bin(d.roles) : nil();
    var module = 'module' in d && d.module ? atom(d.module) : nil();
    return tuple(tup,name,roles,module); }

function lenreceiveTask() { return 4; }
function decreceiveTask(d) {
    var r={}; r.tup = 'receiveTask';
    r.name = d && d.v[1] ? d.v[1].v : undefined;
    r.roles = d && d.v[2] ? utf8_dec(d.v[2].v) : undefined;
    r.module = d && d.v[3] ? d.v[3].v : undefined;
    return clean(r); }

function encmessageEvent(d) {
    var tup = atom('messageEvent');
    var name = 'name' in d && d.name ? atom(d.name) : nil();
    var payload = 'payload' in d && d.payload ? bin(d.payload) : nil();
    var timeout = 'timeout' in d && d.timeout ? encode(d.timeout) : nil();
    return tuple(tup,name,payload,timeout); }

function lenmessageEvent() { return 4; }
function decmessageEvent(d) {
    var r={}; r.tup = 'messageEvent';
    r.name = d && d.v[1] ? d.v[1].v : undefined;
    r.payload = d && d.v[2] ? utf8_dec(d.v[2].v) : undefined;
    r.timeout = d && d.v[3] ? decode(d.v[3].v) : undefined;
    return clean(r); }

function encboundaryEvent(d) {
    var tup = atom('boundaryEvent');
    var name = 'name' in d && d.name ? atom(d.name) : nil();
    var payload = 'payload' in d && d.payload ? bin(d.payload) : nil();
    var timeout = 'timeout' in d && d.timeout ? encode(d.timeout) : nil();
    var timeDate = 'timeDate' in d && d.timeDate ? bin(d.timeDate) : nil();
    var timeDuration = 'timeDuration' in d && d.timeDuration ? bin(d.timeDuration) : nil();
    var timeCycle = 'timeCycle' in d && d.timeCycle ? bin(d.timeCycle) : nil();
    var module = 'module' in d && d.module ? atom(d.module) : nil();
    return tuple(tup,name,payload,timeout,timeDate,timeDuration,timeCycle,module); }

function lenboundaryEvent() { return 8; }
function decboundaryEvent(d) {
    var r={}; r.tup = 'boundaryEvent';
    r.name = d && d.v[1] ? d.v[1].v : undefined;
    r.payload = d && d.v[2] ? utf8_dec(d.v[2].v) : undefined;
    r.timeout = d && d.v[3] ? decode(d.v[3].v) : undefined;
    r.timeDate = d && d.v[4] ? utf8_dec(d.v[4].v) : undefined;
    r.timeDuration = d && d.v[5] ? utf8_dec(d.v[5].v) : undefined;
    r.timeCycle = d && d.v[6] ? utf8_dec(d.v[6].v) : undefined;
    r.module = d && d.v[7] ? d.v[7].v : undefined;
    return clean(r); }

function enctimeoutEvent(d) {
    var tup = atom('timeoutEvent');
    var name = 'name' in d && d.name ? atom(d.name) : nil();
    var payload = 'payload' in d && d.payload ? bin(d.payload) : nil();
    var timeout = 'timeout' in d && d.timeout ? encode(d.timeout) : nil();
    var timeDate = 'timeDate' in d && d.timeDate ? bin(d.timeDate) : nil();
    var timeDuration = 'timeDuration' in d && d.timeDuration ? bin(d.timeDuration) : nil();
    var timeCycle = 'timeCycle' in d && d.timeCycle ? bin(d.timeCycle) : nil();
    var module = 'module' in d && d.module ? atom(d.module) : nil();
    return tuple(tup,name,payload,timeout,timeDate,timeDuration,timeCycle,module); }

function lentimeoutEvent() { return 8; }
function dectimeoutEvent(d) {
    var r={}; r.tup = 'timeoutEvent';
    r.name = d && d.v[1] ? d.v[1].v : undefined;
    r.payload = d && d.v[2] ? utf8_dec(d.v[2].v) : undefined;
    r.timeout = d && d.v[3] ? decode(d.v[3].v) : undefined;
    r.timeDate = d && d.v[4] ? utf8_dec(d.v[4].v) : undefined;
    r.timeDuration = d && d.v[5] ? utf8_dec(d.v[5].v) : undefined;
    r.timeCycle = d && d.v[6] ? utf8_dec(d.v[6].v) : undefined;
    r.module = d && d.v[7] ? d.v[7].v : undefined;
    return clean(r); }

function encbeginEvent(d) {
    var tup = atom('beginEvent');
    var name = 'name' in d && d.name ? atom(d.name) : nil();
    var module = 'module' in d && d.module ? atom(d.module) : nil();
    return tuple(tup,name,module); }

function lenbeginEvent() { return 3; }
function decbeginEvent(d) {
    var r={}; r.tup = 'beginEvent';
    r.name = d && d.v[1] ? d.v[1].v : undefined;
    r.module = d && d.v[2] ? d.v[2].v : undefined;
    return clean(r); }

function encendEvent(d) {
    var tup = atom('endEvent');
    var name = 'name' in d && d.name ? atom(d.name) : nil();
    var module = 'module' in d && d.module ? atom(d.module) : nil();
    return tuple(tup,name,module); }

function lenendEvent() { return 3; }
function decendEvent(d) {
    var r={}; r.tup = 'endEvent';
    r.name = d && d.v[1] ? d.v[1].v : undefined;
    r.module = d && d.v[2] ? d.v[2].v : undefined;
    return clean(r); }

function encsequenceFlow(d) {
    var tup = atom('sequenceFlow');
    var source = 'source' in d && d.source ? atom(d.source) : nil();
    var target = 'target' in d && d.target ? atom(d.target) : nil();
    return tuple(tup,source,target); }

function lensequenceFlow() { return 3; }
function decsequenceFlow(d) {
    var r={}; r.tup = 'sequenceFlow';
    r.source = d && d.v[1] ? d.v[1].v : undefined;
    r.target = d && d.v[2] ? d.v[2].v : undefined;
    return clean(r); }

function enchist(d) {
    var tup = atom('hist');
    var id = 'id' in d && d.id ? number(d.id) : nil();
    var container = 'container' in d && d.container ? atom(d.container) : nil();
    var feed_id = 'feed_id' in d && d.feed_id ? encode(d.feed_id) : nil();
    var prev = 'prev' in d && d.prev ? number(d.prev) : nil();
    var next = 'next' in d && d.next ? number(d.next) : nil();
    var feeds = []; if ('feeds' in d && d.feeds)
	 { d.feeds.forEach(function(x){
	feeds.push(encode(x))});
	 feeds={t:108,v:feeds}; } else { feeds = nil() };
    var name = 'name' in d && d.name ? bin(d.name) : nil();
    var task = 'task' in d && d.task ? atom(d.task) : nil();
    var time = 'time' in d && d.time ? encode(d.time) : nil();
    return tuple(tup,id,container,feed_id,prev,next,feeds,name,task,time); }

function lenhist() { return 10; }
function dechist(d) {
    var r={}; r.tup = 'hist';
    r.id = d && d.v[1] ? d.v[1].v : undefined;
    r.container = d && d.v[2] ? d.v[2].v : undefined;
    r.feed_id = d && d.v[3] ? decode(d.v[3].v) : undefined;
    r.prev = d && d.v[4] ? d.v[4].v : undefined;
    r.next = d && d.v[5] ? d.v[5].v : undefined;
    r.feeds = [];
	 (d && d.v[6] && d.v[6].v) ?
	 d.v[6].v.forEach(function(x){r.feeds.push(decode(x))}) :
	 r.feeds = undefined;
    r.name = d && d.v[7] ? utf8_dec(d.v[7].v) : undefined;
    r.task = d && d.v[8] ? d.v[8].v : undefined;
    r.time = d && d.v[9] ? decode(d.v[9].v) : undefined;
    return clean(r); }

function encprocess(d) {
    var tup = atom('process');
    var id = 'id' in d && d.id ? number(d.id) : nil();
    var container = 'container' in d && d.container ? atom(d.container) : nil();
    var feed_id = 'feed_id' in d && d.feed_id ? encode(d.feed_id) : nil();
    var prev = 'prev' in d && d.prev ? number(d.prev) : nil();
    var next = 'next' in d && d.next ? number(d.next) : nil();
    var feeds = []; if ('feeds' in d && d.feeds)
	 { d.feeds.forEach(function(x){
	feeds.push(encode(x))});
	 feeds={t:108,v:feeds}; } else { feeds = nil() };
    var name = 'name' in d && d.name ? bin(d.name) : nil();
    var roles = []; if ('roles' in d && d.roles)
	 { d.roles.forEach(function(x){
	roles.push(encode(x))});
	 roles={t:108,v:roles}; } else { roles = nil() };
    var tasks = []; if ('tasks' in d && d.tasks)
	 { d.tasks.forEach(function(x){
	tasks.push(encode(x))});
	 tasks={t:108,v:tasks}; } else { tasks = nil() };
    var events = []; if ('events' in d && d.events)
	 { d.events.forEach(function(x){
	events.push(encode(x))});
	 events={t:108,v:events}; } else { events = nil() };
    var hist = 'hist' in d && d.hist ? encode(d.hist) : nil();
    var flows = []; if ('flows' in d && d.flows)
	 { d.flows.forEach(function(x){
	flows.push(encode(x))});
	 flows={t:108,v:flows}; } else { flows = nil() };
    var rules = 'rules' in d && d.rules ? encode(d.rules) : nil();
    var docs = []; if ('docs' in d && d.docs)
	 { d.docs.forEach(function(x){
	docs.push(encode(x))});
	 docs={t:108,v:docs}; } else { docs = nil() };
    var options = 'options' in d && d.options ? encode(d.options) : nil();
    var task = 'task' in d && d.task ? atom(d.task) : nil();
    var timer = 'timer' in d && d.timer ? bin(d.timer) : nil();
    var notifications = 'notifications' in d && d.notifications ? encode(d.notifications) : nil();
    var result = 'result' in d && d.result ? bin(d.result) : nil();
    var started = 'started' in d && d.started ? bin(d.started) : nil();
    var beginEvent = 'beginEvent' in d && d.beginEvent ? atom(d.beginEvent) : nil();
    var endEvent = 'endEvent' in d && d.endEvent ? atom(d.endEvent) : nil();
    return tuple(tup,id,container,feed_id,prev,next,feeds,name,roles,tasks,events,
	hist,flows,rules,docs,options,task,timer,notifications,result,started,beginEvent,endEvent); }

function lenprocess() { return 23; }
function decprocess(d) {
    var r={}; r.tup = 'process';
    r.id = d && d.v[1] ? d.v[1].v : undefined;
    r.container = d && d.v[2] ? d.v[2].v : undefined;
    r.feed_id = d && d.v[3] ? decode(d.v[3].v) : undefined;
    r.prev = d && d.v[4] ? d.v[4].v : undefined;
    r.next = d && d.v[5] ? d.v[5].v : undefined;
    r.feeds = [];
	 (d && d.v[6] && d.v[6].v) ?
	 d.v[6].v.forEach(function(x){r.feeds.push(decode(x))}) :
	 r.feeds = undefined;
    r.name = d && d.v[7] ? utf8_dec(d.v[7].v) : undefined;
    r.roles = [];
	 (d && d.v[8] && d.v[8].v) ?
	 d.v[8].v.forEach(function(x){r.roles.push(decode(x))}) :
	 r.roles = undefined;
    r.tasks = [];
	 (d && d.v[9] && d.v[9].v) ?
	 d.v[9].v.forEach(function(x){r.tasks.push(decode(x))}) :
	 r.tasks = undefined;
    r.events = [];
	 (d && d.v[10] && d.v[10].v) ?
	 d.v[10].v.forEach(function(x){r.events.push(decode(x))}) :
	 r.events = undefined;
    r.hist = d && d.v[11] ? decode(d.v[11]) : undefined;
    r.flows = [];
	 (d && d.v[12] && d.v[12].v) ?
	 d.v[12].v.forEach(function(x){r.flows.push(decode(x))}) :
	 r.flows = undefined;
    r.rules = d && d.v[13] ? decode(d.v[13]) : undefined;
    r.docs = [];
	 (d && d.v[14] && d.v[14].v) ?
	 d.v[14].v.forEach(function(x){r.docs.push(decode(x))}) :
	 r.docs = undefined;
    r.options = d && d.v[15] ? decode(d.v[15].v) : undefined;
    r.task = d && d.v[16] ? d.v[16].v : undefined;
    r.timer = d && d.v[17] ? utf8_dec(d.v[17].v) : undefined;
    r.notifications = d && d.v[18] ? decode(d.v[18].v) : undefined;
    r.result = d && d.v[19] ? utf8_dec(d.v[19].v) : undefined;
    r.started = d && d.v[20] ? utf8_dec(d.v[20].v) : undefined;
    r.beginEvent = d && d.v[21] ? d.v[21].v : undefined;
    r.endEvent = d && d.v[22] ? d.v[22].v : undefined;
    return clean(r); }

function enccomplete(d) {
    var tup = atom('complete');
    var id = 'id' in d && d.id ? number(d.id) : nil();
    return tuple(tup,id); }

function lencomplete() { return 2; }
function deccomplete(d) {
    var r={}; r.tup = 'complete';
    r.id = d && d.v[1] ? d.v[1].v : undefined;
    return clean(r); }

function encproc(d) {
    var tup = atom('proc');
    var id = 'id' in d && d.id ? number(d.id) : nil();
    return tuple(tup,id); }

function lenproc() { return 2; }
function decproc(d) {
    var r={}; r.tup = 'proc';
    r.id = d && d.v[1] ? d.v[1].v : undefined;
    return clean(r); }

function enchisto(d) {
    var tup = atom('histo');
    var id = 'id' in d && d.id ? number(d.id) : nil();
    return tuple(tup,id); }

function lenhisto() { return 2; }
function dechisto(d) {
    var r={}; r.tup = 'histo';
    r.id = d && d.v[1] ? d.v[1].v : undefined;
    return clean(r); }

function enccreate(d) {
    var tup = atom('create');
    var proc = 'proc' in d && d.proc ? encode(d.proc) : nil();
    var docs = []; if ('docs' in d && d.docs)
	 { d.docs.forEach(function(x){
	docs.push(encode(x))});
	 docs={t:108,v:docs}; } else { docs = nil() };
    return tuple(tup,proc,docs); }

function lencreate() { return 3; }
function deccreate(d) {
    var r={}; r.tup = 'create';
    r.proc = d && d.v[1] ? decode(d.v[1]) : undefined;
    r.docs = [];
	 (d && d.v[2] && d.v[2].v) ?
	 d.v[2].v.forEach(function(x){r.docs.push(decode(x))}) :
	 r.docs = undefined;
    return clean(r); }

function encamend(d) {
    var tup = atom('amend');
    var id = 'id' in d && d.id ? number(d.id) : nil();
    var docs = []; if ('docs' in d && d.docs)
	 { d.docs.forEach(function(x){
	docs.push(encode(x))});
	 docs={t:108,v:docs}; } else { docs = nil() };
    return tuple(tup,id,docs); }

function lenamend() { return 3; }
function decamend(d) {
    var r={}; r.tup = 'amend';
    r.id = d && d.v[1] ? d.v[1].v : undefined;
    r.docs = [];
	 (d && d.v[2] && d.v[2].v) ?
	 d.v[2].v.forEach(function(x){r.docs.push(decode(x))}) :
	 r.docs = undefined;
    return clean(r); }

function encchain(d) {
    var tup = atom('chain');
    var id = 'id' in d && d.id ? number(d.id) : nil();
    var top = 'top' in d && d.top ? number(d.top) : nil();
    var rear = 'rear' in d && d.rear ? number(d.rear) : nil();
    var count = 'count' in d && d.count ? number(d.count) : nil();
    return tuple(tup,id,top,rear,count); }

function lenchain() { return 5; }
function decchain(d) {
    var r={}; r.tup = 'chain';
    r.id = d && d.v[1] ? d.v[1].v : undefined;
    r.top = d && d.v[2] ? d.v[2].v : undefined;
    r.rear = d && d.v[3] ? d.v[3].v : undefined;
    r.count = d && d.v[4] ? d.v[4].v : undefined;
    return clean(r); }

function encpush(d) {
    var tup = atom('push');
    var model = 'model' in d && d.model ? encode(d.model) : nil();
    var type = 'type' in d && d.type ? bin(d.type) : nil();
    var title = 'title' in d && d.title ? bin(d.title) : nil();
    var alert = 'alert' in d && d.alert ? bin(d.alert) : nil();
    var badge = 'badge' in d && d.badge ? number(d.badge) : nil();
    var sound = 'sound' in d && d.sound ? bin(d.sound) : nil();
    return tuple(tup,model,type,title,alert,badge,sound); }

function lenpush() { return 7; }
function decpush(d) {
    var r={}; r.tup = 'push';
    r.model = d && d.v[1] ? decode(d.v[1].v) : undefined;
    r.type = d && d.v[2] ? utf8_dec(d.v[2].v) : undefined;
    r.title = d && d.v[3] ? utf8_dec(d.v[3].v) : undefined;
    r.alert = d && d.v[4] ? utf8_dec(d.v[4].v) : undefined;
    r.badge = d && d.v[5] ? d.v[5].v : undefined;
    r.sound = d && d.v[6] ? utf8_dec(d.v[6].v) : undefined;
    return clean(r); }

function encSearch(d) {
    var tup = atom('Search');
    var id = 'id' in d && d.id ? number(d.id) : nil();
    var ref = 'ref' in d && d.ref ? bin(d.ref) : nil();
    var field = 'field' in d && d.field ? bin(d.field) : nil();
    var type = 'type' in d && d.type ? atom(d.type) : nil();
    var value = 'value' in d && d.value ? encode(d.value) : nil();
    var status = 'status' in d && d.status ? atom(d.status) : nil();
    return tuple(tup,id,ref,field,type,value,status); }

function lenSearch() { return 7; }
function decSearch(d) {
    var r={}; r.tup = 'Search';
    r.id = d && d.v[1] ? d.v[1].v : undefined;
    r.ref = d && d.v[2] ? utf8_dec(d.v[2].v) : undefined;
    r.field = d && d.v[3] ? utf8_dec(d.v[3].v) : undefined;
    r.type = d && d.v[4] ? decode(d.v[4]) : undefined;
    r.value = d && d.v[5] ? decode(d.v[5].v) : undefined;
    r.status = d && d.v[6] ? decode(d.v[6]) : undefined;
    return clean(r); }

function encp2p(d) {
    var tup = atom('p2p');
    var from = 'from' in d && d.from ? bin(d.from) : nil();
    var to = 'to' in d && d.to ? bin(d.to) : nil();
    return tuple(tup,from,to); }

function lenp2p() { return 3; }
function decp2p(d) {
    var r={}; r.tup = 'p2p';
    r.from = d && d.v[1] ? utf8_dec(d.v[1].v) : undefined;
    r.to = d && d.v[2] ? utf8_dec(d.v[2].v) : undefined;
    return clean(r); }

function encmuc(d) {
    var tup = atom('muc');
    var name = 'name' in d && d.name ? bin(d.name) : nil();
    return tuple(tup,name); }

function lenmuc() { return 2; }
function decmuc(d) {
    var r={}; r.tup = 'muc';
    r.name = d && d.v[1] ? utf8_dec(d.v[1].v) : undefined;
    return clean(r); }

function encmqi(d) {
    var tup = atom('mqi');
    var feed_id = 'feed_id' in d && d.feed_id ? encode(d.feed_id) : nil();
    var query = 'query' in d && d.query ? bin(d.query) : nil();
    var status = 'status' in d && d.status ? atom(d.status) : nil();
    return tuple(tup,feed_id,query,status); }

function lenmqi() { return 4; }
function decmqi(d) {
    var r={}; r.tup = 'mqi';
    r.feed_id = d && d.v[1] ? decode(d.v[1]) : undefined;
    r.query = d && d.v[2] ? utf8_dec(d.v[2].v) : undefined;
    r.status = d && d.v[3] ? decode(d.v[3]) : undefined;
    return clean(r); }

function encCDR(d) {
    var tup = atom('CDR');
    var id = 'id' in d && d.id ? number(d.id) : nil();
    var container = 'container' in d && d.container ? atom(d.container) : nil();
    var feed = 'feed' in d && d.feed ? encode(d.feed) : nil();
    var next = 'next' in d && d.next ? number(d.next) : nil();
    var prev = 'prev' in d && d.prev ? number(d.prev) : nil();
    var from = 'from' in d && d.from ? bin(d.from) : nil();
    var to = 'to' in d && d.to ? bin(d.to) : nil();
    var start = 'start' in d && d.start ? number(d.start) : nil();
    var stop = 'stop' in d && d.stop ? number(d.stop) : nil();
    var type = 'type' in d && d.type ? atom(d.type) : nil();
    var desc = 'desc' in d && d.desc ? bin(d.desc) : nil();
    var bill = 'bill' in d && d.bill ? number(d.bill) : nil();
    var tariff = 'tariff' in d && d.tariff ? bin(d.tariff) : nil();
    return tuple(tup,id,container,feed,next,prev,from,to,start,stop,type,
	desc,bill,tariff); }

function lenCDR() { return 14; }
function decCDR(d) {
    var r={}; r.tup = 'CDR';
    r.id = d && d.v[1] ? d.v[1].v : undefined;
    r.container = d && d.v[2] ? d.v[2].v : undefined;
    r.feed = d && d.v[3] ? decode(d.v[3].v) : undefined;
    r.next = d && d.v[4] ? d.v[4].v : undefined;
    r.prev = d && d.v[5] ? d.v[5].v : undefined;
    r.from = d && d.v[6] ? utf8_dec(d.v[6].v) : undefined;
    r.to = d && d.v[7] ? utf8_dec(d.v[7].v) : undefined;
    r.start = d && d.v[8] ? d.v[8].v : undefined;
    r.stop = d && d.v[9] ? d.v[9].v : undefined;
    r.type = d && d.v[10] ? decode(d.v[10]) : undefined;
    r.desc = d && d.v[11] ? utf8_dec(d.v[11].v) : undefined;
    r.bill = d && d.v[12] ? d.v[12].v : undefined;
    r.tariff = d && d.v[13] ? utf8_dec(d.v[13].v) : undefined;
    return clean(r); }

function encFeature(d) {
    var tup = atom('Feature');
    var id = 'id' in d && d.id ? bin(d.id) : nil();
    var key = 'key' in d && d.key ? bin(d.key) : nil();
    var value = 'value' in d && d.value ? bin(d.value) : nil();
    var group = 'group' in d && d.group ? bin(d.group) : nil();
    return tuple(tup,id,key,value,group); }

function lenFeature() { return 5; }
function decFeature(d) {
    var r={}; r.tup = 'Feature';
    r.id = d && d.v[1] ? utf8_dec(d.v[1].v) : undefined;
    r.key = d && d.v[2] ? utf8_dec(d.v[2].v) : undefined;
    r.value = d && d.v[3] ? utf8_dec(d.v[3].v) : undefined;
    r.group = d && d.v[4] ? utf8_dec(d.v[4].v) : undefined;
    return clean(r); }

function encService(d) {
    var tup = atom('Service');
    var id = 'id' in d && d.id ? bin(d.id) : nil();
    var type = 'type' in d && d.type ? atom(d.type) : nil();
    var data = 'data' in d && d.data ? encode(d.data) : nil();
    var login = 'login' in d && d.login ? bin(d.login) : nil();
    var password = 'password' in d && d.password ? bin(d.password) : nil();
    var expiration = 'expiration' in d && d.expiration ? number(d.expiration) : nil();
    var status = 'status' in d && d.status ? atom(d.status) : nil();
    return tuple(tup,id,type,data,login,password,expiration,status); }

function lenService() { return 8; }
function decService(d) {
    var r={}; r.tup = 'Service';
    r.id = d && d.v[1] ? utf8_dec(d.v[1].v) : undefined;
    r.type = d && d.v[2] ? decode(d.v[2]) : undefined;
    r.data = d && d.v[3] ? decode(d.v[3].v) : undefined;
    r.login = d && d.v[4] ? utf8_dec(d.v[4].v) : undefined;
    r.password = d && d.v[5] ? utf8_dec(d.v[5].v) : undefined;
    r.expiration = d && d.v[6] ? d.v[6].v : undefined;
    r.status = d && d.v[7] ? decode(d.v[7]) : undefined;
    return clean(r); }

function encMember(d) {
    var tup = atom('Member');
    var id = 'id' in d && d.id ? number(d.id) : nil();
    var container = 'container' in d && d.container ? atom(d.container) : nil();
    var feed_id = 'feed_id' in d && d.feed_id ? encode(d.feed_id) : nil();
    var prev = 'prev' in d && d.prev ? number(d.prev) : nil();
    var next = 'next' in d && d.next ? number(d.next) : nil();
    var feeds = []; if ('feeds' in d && d.feeds)
	 { d.feeds.forEach(function(x){
	feeds.push(encode(x))});
	 feeds={t:108,v:feeds}; } else { feeds = nil() };
    var phone_id = 'phone_id' in d && d.phone_id ? bin(d.phone_id) : nil();
    var avatar = 'avatar' in d && d.avatar ? bin(d.avatar) : nil();
    var names = 'names' in d && d.names ? bin(d.names) : nil();
    var surnames = 'surnames' in d && d.surnames ? bin(d.surnames) : nil();
    var alias = 'alias' in d && d.alias ? bin(d.alias) : nil();
    var reader = 'reader' in d && d.reader ? number(d.reader) : nil();
    var update = 'update' in d && d.update ? number(d.update) : nil();
    var settings = []; if ('settings' in d && d.settings)
	 { d.settings.forEach(function(x){
	settings.push(encode(x))});
	 settings={t:108,v:settings}; } else { settings = nil() };
    var services = []; if ('services' in d && d.services)
	 { d.services.forEach(function(x){
	services.push(encode(x))});
	 services={t:108,v:services}; } else { services = nil() };
    var presence = 'presence' in d && d.presence ? atom(d.presence) : nil();
    var status = 'status' in d && d.status ? atom(d.status) : nil();
    return tuple(tup,id,container,feed_id,prev,next,feeds,phone_id,avatar,names,surnames,
	alias,reader,update,settings,services,presence,status); }

function lenMember() { return 18; }
function decMember(d) {
    var r={}; r.tup = 'Member';
    r.id = d && d.v[1] ? d.v[1].v : undefined;
    r.container = d && d.v[2] ? decode(d.v[2]) : undefined;
    r.feed_id = d && d.v[3] ? decode(d.v[3]) : undefined;
    r.prev = d && d.v[4] ? d.v[4].v : undefined;
    r.next = d && d.v[5] ? d.v[5].v : undefined;
    r.feeds = [];
	 (d && d.v[6] && d.v[6].v) ?
	 d.v[6].v.forEach(function(x){r.feeds.push(decode(x))}) :
	 r.feeds = undefined;
    r.phone_id = d && d.v[7] ? utf8_dec(d.v[7].v) : undefined;
    r.avatar = d && d.v[8] ? utf8_dec(d.v[8].v) : undefined;
    r.names = d && d.v[9] ? utf8_dec(d.v[9].v) : undefined;
    r.surnames = d && d.v[10] ? utf8_dec(d.v[10].v) : undefined;
    r.alias = d && d.v[11] ? utf8_dec(d.v[11].v) : undefined;
    r.reader = d && d.v[12] ? d.v[12].v : undefined;
    r.update = d && d.v[13] ? d.v[13].v : undefined;
    r.settings = [];
	 (d && d.v[14] && d.v[14].v) ?
	 d.v[14].v.forEach(function(x){r.settings.push(decode(x))}) :
	 r.settings = undefined;
    r.services = [];
	 (d && d.v[15] && d.v[15].v) ?
	 d.v[15].v.forEach(function(x){r.services.push(decode(x))}) :
	 r.services = undefined;
    r.presence = d && d.v[16] ? decode(d.v[16]) : undefined;
    r.status = d && d.v[17] ? decode(d.v[17]) : undefined;
    return clean(r); }

function encDesc(d) {
    var tup = atom('Desc');
    var id = 'id' in d && d.id ? bin(d.id) : nil();
    var mime = 'mime' in d && d.mime ? bin(d.mime) : nil();
    var payload = 'payload' in d && d.payload ? bin(d.payload) : nil();
    var parentid = 'parentid' in d && d.parentid ? bin(d.parentid) : nil();
    var data = []; if ('data' in d && d.data)
	 { d.data.forEach(function(x){
	data.push(encode(x))});
	 data={t:108,v:data}; } else { data = nil() };
    return tuple(tup,id,mime,payload,parentid,data); }

function lenDesc() { return 6; }
function decDesc(d) {
    var r={}; r.tup = 'Desc';
    r.id = d && d.v[1] ? utf8_dec(d.v[1].v) : undefined;
    r.mime = d && d.v[2] ? utf8_dec(d.v[2].v) : undefined;
    r.payload = d && d.v[3] ? utf8_dec(d.v[3].v) : undefined;
    r.parentid = d && d.v[4] ? utf8_dec(d.v[4].v) : undefined;
    r.data = [];
	 (d && d.v[5] && d.v[5].v) ?
	 d.v[5].v.forEach(function(x){r.data.push(decode(x))}) :
	 r.data = undefined;
    return clean(r); }

function encStickerPack(d) {
    var tup = atom('StickerPack');
    var id = 'id' in d && d.id ? number(d.id) : nil();
    var name = 'name' in d && d.name ? bin(d.name) : nil();
    var keywords = []; if ('keywords' in d && d.keywords)
	 { d.keywords.forEach(function(x){
	keywords.push(encode(x))});
	 keywords={t:108,v:keywords}; } else { keywords = nil() };
    var description = 'description' in d && d.description ? bin(d.description) : nil();
    var author = 'author' in d && d.author ? bin(d.author) : nil();
    var stickers = []; if ('stickers' in d && d.stickers)
	 { d.stickers.forEach(function(x){
	stickers.push(encode(x))});
	 stickers={t:108,v:stickers}; } else { stickers = nil() };
    var created = 'created' in d && d.created ? number(d.created) : nil();
    var updated = 'updated' in d && d.updated ? number(d.updated) : nil();
    var downloaded = 'downloaded' in d && d.downloaded ? number(d.downloaded) : nil();
    return tuple(tup,id,name,keywords,description,author,stickers,created,updated,downloaded); }

function lenStickerPack() { return 10; }
function decStickerPack(d) {
    var r={}; r.tup = 'StickerPack';
    r.id = d && d.v[1] ? d.v[1].v : undefined;
    r.name = d && d.v[2] ? utf8_dec(d.v[2].v) : undefined;
    r.keywords = [];
	 (d && d.v[3] && d.v[3].v) ?
	 d.v[3].v.forEach(function(x){r.keywords.push(decode(x))}) :
	 r.keywords = undefined;
    r.description = d && d.v[4] ? utf8_dec(d.v[4].v) : undefined;
    r.author = d && d.v[5] ? utf8_dec(d.v[5].v) : undefined;
    r.stickers = [];
	 (d && d.v[6] && d.v[6].v) ?
	 d.v[6].v.forEach(function(x){r.stickers.push(decode(x))}) :
	 r.stickers = undefined;
    r.created = d && d.v[7] ? d.v[7].v : undefined;
    r.updated = d && d.v[8] ? d.v[8].v : undefined;
    r.downloaded = d && d.v[9] ? d.v[9].v : undefined;
    return clean(r); }

function encMessage(d) {
    var tup = atom('Message');
    var id = 'id' in d && d.id ? number(d.id) : nil();
    var container = 'container' in d && d.container ? atom(d.container) : nil();
    var feed_id = 'feed_id' in d && d.feed_id ? encode(d.feed_id) : nil();
    var prev = 'prev' in d && d.prev ? number(d.prev) : nil();
    var next = 'next' in d && d.next ? number(d.next) : nil();
    var msg_id = 'msg_id' in d && d.msg_id ? bin(d.msg_id) : nil();
    var from = 'from' in d && d.from ? bin(d.from) : nil();
    var to = 'to' in d && d.to ? bin(d.to) : nil();
    var created = 'created' in d && d.created ? number(d.created) : nil();
    var files = []; if ('files' in d && d.files)
	 { d.files.forEach(function(x){
	files.push(encode(x))});
	 files={t:108,v:files}; } else { files = nil() };
    var type = []; if ('type' in d && d.type)
	 { d.type.forEach(function(x){
	type.push(encode(x))});
	 type={t:108,v:type}; } else { type = nil() };
    var link = 'link' in d && d.link ? number(d.link) : nil();
    var seenby = []; if ('seenby' in d && d.seenby)
	 { d.seenby.forEach(function(x){
	seenby.push(encode(x))});
	 seenby={t:108,v:seenby}; } else { seenby = nil() };
    var repliedby = []; if ('repliedby' in d && d.repliedby)
	 { d.repliedby.forEach(function(x){
	repliedby.push(encode(x))});
	 repliedby={t:108,v:repliedby}; } else { repliedby = nil() };
    var mentioned = []; if ('mentioned' in d && d.mentioned)
	 { d.mentioned.forEach(function(x){
	mentioned.push(encode(x))});
	 mentioned={t:108,v:mentioned}; } else { mentioned = nil() };
    var status = 'status' in d && d.status ? atom(d.status) : nil();
    return tuple(tup,id,container,feed_id,prev,next,msg_id,from,to,created,files,
	type,link,seenby,repliedby,mentioned,status); }

function lenMessage() { return 17; }
function decMessage(d) {
    var r={}; r.tup = 'Message';
    r.id = d && d.v[1] ? d.v[1].v : undefined;
    r.container = d && d.v[2] ? decode(d.v[2]) : undefined;
    r.feed_id = d && d.v[3] ? decode(d.v[3]) : undefined;
    r.prev = d && d.v[4] ? d.v[4].v : undefined;
    r.next = d && d.v[5] ? d.v[5].v : undefined;
    r.msg_id = d && d.v[6] ? utf8_dec(d.v[6].v) : undefined;
    r.from = d && d.v[7] ? utf8_dec(d.v[7].v) : undefined;
    r.to = d && d.v[8] ? utf8_dec(d.v[8].v) : undefined;
    r.created = d && d.v[9] ? d.v[9].v : undefined;
    r.files = [];
	 (d && d.v[10] && d.v[10].v) ?
	 d.v[10].v.forEach(function(x){r.files.push(decode(x))}) :
	 r.files = undefined;
    r.type = [];
	 (d && d.v[11] && d.v[11].v) ?
	 d.v[11].v.forEach(function(x){r.type.push(decode(x))}) :
	 r.type = undefined;
    r.link = d && d.v[12] ? d.v[12].v : undefined;
    r.seenby = [];
	 (d && d.v[13] && d.v[13].v) ?
	 d.v[13].v.forEach(function(x){r.seenby.push(decode(x))}) :
	 r.seenby = undefined;
    r.repliedby = [];
	 (d && d.v[14] && d.v[14].v) ?
	 d.v[14].v.forEach(function(x){r.repliedby.push(decode(x))}) :
	 r.repliedby = undefined;
    r.mentioned = [];
	 (d && d.v[15] && d.v[15].v) ?
	 d.v[15].v.forEach(function(x){r.mentioned.push(decode(x))}) :
	 r.mentioned = undefined;
    r.status = d && d.v[16] ? decode(d.v[16]) : undefined;
    return clean(r); }

function encLink(d) {
    var tup = atom('Link');
    var id = 'id' in d && d.id ? bin(d.id) : nil();
    var name = 'name' in d && d.name ? bin(d.name) : nil();
    var room_id = 'room_id' in d && d.room_id ? bin(d.room_id) : nil();
    var created = 'created' in d && d.created ? number(d.created) : nil();
    var status = 'status' in d && d.status ? encode(d.status) : nil();
    return tuple(tup,id,name,room_id,created,status); }

function lenLink() { return 6; }
function decLink(d) {
    var r={}; r.tup = 'Link';
    r.id = d && d.v[1] ? utf8_dec(d.v[1].v) : undefined;
    r.name = d && d.v[2] ? utf8_dec(d.v[2].v) : undefined;
    r.room_id = d && d.v[3] ? utf8_dec(d.v[3].v) : undefined;
    r.created = d && d.v[4] ? d.v[4].v : undefined;
    r.status = d && d.v[5] ? decode(d.v[5]) : undefined;
    return clean(r); }

function encRoom(d) {
    var tup = atom('Room');
    var id = 'id' in d && d.id ? bin(d.id) : nil();
    var name = 'name' in d && d.name ? bin(d.name) : nil();
    var links = []; if ('links' in d && d.links)
	 { d.links.forEach(function(x){
	links.push(encode(x))});
	 links={t:108,v:links}; } else { links = nil() };
    var description = 'description' in d && d.description ? bin(d.description) : nil();
    var settings = []; if ('settings' in d && d.settings)
	 { d.settings.forEach(function(x){
	settings.push(encode(x))});
	 settings={t:108,v:settings}; } else { settings = nil() };
    var members = []; if ('members' in d && d.members)
	 { d.members.forEach(function(x){
	members.push(encode(x))});
	 members={t:108,v:members}; } else { members = nil() };
    var admins = []; if ('admins' in d && d.admins)
	 { d.admins.forEach(function(x){
	admins.push(encode(x))});
	 admins={t:108,v:admins}; } else { admins = nil() };
    var data = []; if ('data' in d && d.data)
	 { d.data.forEach(function(x){
	data.push(encode(x))});
	 data={t:108,v:data}; } else { data = nil() };
    var type = 'type' in d && d.type ? atom(d.type) : nil();
    var tos = 'tos' in d && d.tos ? bin(d.tos) : nil();
    var tos_update = 'tos_update' in d && d.tos_update ? number(d.tos_update) : nil();
    var unread = 'unread' in d && d.unread ? number(d.unread) : nil();
    var mentions = []; if ('mentions' in d && d.mentions)
	 { d.mentions.forEach(function(x){
	mentions.push(encode(x))});
	 mentions={t:108,v:mentions}; } else { mentions = nil() };
    var readers = []; if ('readers' in d && d.readers)
	 { d.readers.forEach(function(x){
	readers.push(encode(x))});
	 readers={t:108,v:readers}; } else { readers = nil() };
    var last_msg = 'last_msg' in d && d.last_msg ? encode(d.last_msg) : nil();
    var update = 'update' in d && d.update ? number(d.update) : nil();
    var created = 'created' in d && d.created ? number(d.created) : nil();
    var status = 'status' in d && d.status ? atom(d.status) : nil();
    return tuple(tup,id,name,links,description,settings,members,admins,data,type,tos,
	tos_update,unread,mentions,readers,last_msg,update,created,status); }

function lenRoom() { return 19; }
function decRoom(d) {
    var r={}; r.tup = 'Room';
    r.id = d && d.v[1] ? utf8_dec(d.v[1].v) : undefined;
    r.name = d && d.v[2] ? utf8_dec(d.v[2].v) : undefined;
    r.links = [];
	 (d && d.v[3] && d.v[3].v) ?
	 d.v[3].v.forEach(function(x){r.links.push(decode(x))}) :
	 r.links = undefined;
    r.description = d && d.v[4] ? utf8_dec(d.v[4].v) : undefined;
    r.settings = [];
	 (d && d.v[5] && d.v[5].v) ?
	 d.v[5].v.forEach(function(x){r.settings.push(decode(x))}) :
	 r.settings = undefined;
    r.members = [];
	 (d && d.v[6] && d.v[6].v) ?
	 d.v[6].v.forEach(function(x){r.members.push(decode(x))}) :
	 r.members = undefined;
    r.admins = [];
	 (d && d.v[7] && d.v[7].v) ?
	 d.v[7].v.forEach(function(x){r.admins.push(decode(x))}) :
	 r.admins = undefined;
    r.data = [];
	 (d && d.v[8] && d.v[8].v) ?
	 d.v[8].v.forEach(function(x){r.data.push(decode(x))}) :
	 r.data = undefined;
    r.type = d && d.v[9] ? decode(d.v[9]) : undefined;
    r.tos = d && d.v[10] ? utf8_dec(d.v[10].v) : undefined;
    r.tos_update = d && d.v[11] ? d.v[11].v : undefined;
    r.unread = d && d.v[12] ? d.v[12].v : undefined;
    r.mentions = [];
	 (d && d.v[13] && d.v[13].v) ?
	 d.v[13].v.forEach(function(x){r.mentions.push(decode(x))}) :
	 r.mentions = undefined;
    r.readers = [];
	 (d && d.v[14] && d.v[14].v) ?
	 d.v[14].v.forEach(function(x){r.readers.push(decode(x))}) :
	 r.readers = undefined;
    r.last_msg = d && d.v[15] ? decode(d.v[15]) : undefined;
    r.update = d && d.v[16] ? d.v[16].v : undefined;
    r.created = d && d.v[17] ? d.v[17].v : undefined;
    r.status = d && d.v[18] ? decode(d.v[18]) : undefined;
    return clean(r); }

function encTag(d) {
    var tup = atom('Tag');
    var roster_id = 'roster_id' in d && d.roster_id ? bin(d.roster_id) : nil();
    var name = 'name' in d && d.name ? bin(d.name) : nil();
    var color = 'color' in d && d.color ? bin(d.color) : nil();
    var status = 'status' in d && d.status ? atom(d.status) : nil();
    return tuple(tup,roster_id,name,color,status); }

function lenTag() { return 5; }
function decTag(d) {
    var r={}; r.tup = 'Tag';
    r.roster_id = d && d.v[1] ? utf8_dec(d.v[1].v) : undefined;
    r.name = d && d.v[2] ? utf8_dec(d.v[2].v) : undefined;
    r.color = d && d.v[3] ? utf8_dec(d.v[3].v) : undefined;
    r.status = d && d.v[4] ? decode(d.v[4]) : undefined;
    return clean(r); }

function encStar(d) {
    var tup = atom('Star');
    var id = 'id' in d && d.id ? number(d.id) : nil();
    var client_id = 'client_id' in d && d.client_id ? bin(d.client_id) : nil();
    var roster_id = 'roster_id' in d && d.roster_id ? number(d.roster_id) : nil();
    var message = 'message' in d && d.message ? encode(d.message) : nil();
    var tags = []; if ('tags' in d && d.tags)
	 { d.tags.forEach(function(x){
	tags.push(encode(x))});
	 tags={t:108,v:tags}; } else { tags = nil() };
    var status = 'status' in d && d.status ? atom(d.status) : nil();
    return tuple(tup,id,client_id,roster_id,message,tags,status); }

function lenStar() { return 7; }
function decStar(d) {
    var r={}; r.tup = 'Star';
    r.id = d && d.v[1] ? d.v[1].v : undefined;
    r.client_id = d && d.v[2] ? utf8_dec(d.v[2].v) : undefined;
    r.roster_id = d && d.v[3] ? d.v[3].v : undefined;
    r.message = d && d.v[4] ? decode(d.v[4]) : undefined;
    r.tags = [];
	 (d && d.v[5] && d.v[5].v) ?
	 d.v[5].v.forEach(function(x){r.tags.push(decode(x))}) :
	 r.tags = undefined;
    r.status = d && d.v[6] ? decode(d.v[6]) : undefined;
    return clean(r); }

function encTyping(d) {
    var tup = atom('Typing');
    var phone_id = 'phone_id' in d && d.phone_id ? bin(d.phone_id) : nil();
    var comments = 'comments' in d && d.comments ? encode(d.comments) : nil();
    return tuple(tup,phone_id,comments); }

function lenTyping() { return 3; }
function decTyping(d) {
    var r={}; r.tup = 'Typing';
    r.phone_id = d && d.v[1] ? utf8_dec(d.v[1].v) : undefined;
    r.comments = d && d.v[2] ? decode(d.v[2].v) : undefined;
    return clean(r); }

function encContact(d) {
    var tup = atom('Contact');
    var phone_id = 'phone_id' in d && d.phone_id ? bin(d.phone_id) : nil();
    var avatar = 'avatar' in d && d.avatar ? bin(d.avatar) : nil();
    var names = 'names' in d && d.names ? bin(d.names) : nil();
    var surnames = 'surnames' in d && d.surnames ? bin(d.surnames) : nil();
    var nick = 'nick' in d && d.nick ? bin(d.nick) : nil();
    var reader = []; if ('reader' in d && d.reader)
	 { d.reader.forEach(function(x){
	reader.push(encode(x))});
	 reader={t:108,v:reader}; } else { reader = nil() };
    var unread = 'unread' in d && d.unread ? number(d.unread) : nil();
    var last_msg = 'last_msg' in d && d.last_msg ? encode(d.last_msg) : nil();
    var update = 'update' in d && d.update ? number(d.update) : nil();
    var created = 'created' in d && d.created ? number(d.created) : nil();
    var settings = []; if ('settings' in d && d.settings)
	 { d.settings.forEach(function(x){
	settings.push(encode(x))});
	 settings={t:108,v:settings}; } else { settings = nil() };
    var services = []; if ('services' in d && d.services)
	 { d.services.forEach(function(x){
	services.push(encode(x))});
	 services={t:108,v:services}; } else { services = nil() };
    var presence = 'presence' in d && d.presence ? atom(d.presence) : nil();
    var status = 'status' in d && d.status ? atom(d.status) : nil();
    return tuple(tup,phone_id,avatar,names,surnames,nick,reader,unread,last_msg,update,created,
	settings,services,presence,status); }

function lenContact() { return 15; }
function decContact(d) {
    var r={}; r.tup = 'Contact';
    r.phone_id = d && d.v[1] ? utf8_dec(d.v[1].v) : undefined;
    r.avatar = d && d.v[2] ? utf8_dec(d.v[2].v) : undefined;
    r.names = d && d.v[3] ? utf8_dec(d.v[3].v) : undefined;
    r.surnames = d && d.v[4] ? utf8_dec(d.v[4].v) : undefined;
    r.nick = d && d.v[5] ? utf8_dec(d.v[5].v) : undefined;
    r.reader = [];
	 (d && d.v[6] && d.v[6].v) ?
	 d.v[6].v.forEach(function(x){r.reader.push(decode(x))}) :
	 r.reader = undefined;
    r.unread = d && d.v[7] ? d.v[7].v : undefined;
    r.last_msg = d && d.v[8] ? decode(d.v[8]) : undefined;
    r.update = d && d.v[9] ? d.v[9].v : undefined;
    r.created = d && d.v[10] ? d.v[10].v : undefined;
    r.settings = [];
	 (d && d.v[11] && d.v[11].v) ?
	 d.v[11].v.forEach(function(x){r.settings.push(decode(x))}) :
	 r.settings = undefined;
    r.services = [];
	 (d && d.v[12] && d.v[12].v) ?
	 d.v[12].v.forEach(function(x){r.services.push(decode(x))}) :
	 r.services = undefined;
    r.presence = d && d.v[13] ? decode(d.v[13]) : undefined;
    r.status = d && d.v[14] ? decode(d.v[14]) : undefined;
    return clean(r); }

function encExtendedStar(d) {
    var tup = atom('ExtendedStar');
    var star = 'star' in d && d.star ? encode(d.star) : nil();
    var from = 'from' in d && d.from ? encode(d.from) : nil();
    return tuple(tup,star,from); }

function lenExtendedStar() { return 3; }
function decExtendedStar(d) {
    var r={}; r.tup = 'ExtendedStar';
    r.star = d && d.v[1] ? decode(d.v[1]) : undefined;
    r.from = d && d.v[2] ? decode(d.v[2]) : undefined;
    return clean(r); }

function encAuth(d) {
    var tup = atom('Auth');
    var client_id = 'client_id' in d && d.client_id ? bin(d.client_id) : nil();
    var dev_key = 'dev_key' in d && d.dev_key ? bin(d.dev_key) : nil();
    var user_id = 'user_id' in d && d.user_id ? bin(d.user_id) : nil();
    var phone = 'phone' in d && d.phone ? bin(d.phone) : nil();
    var token = 'token' in d && d.token ? bin(d.token) : nil();
    var type = 'type' in d && d.type ? atom(d.type) : nil();
    var sms_code = 'sms_code' in d && d.sms_code ? bin(d.sms_code) : nil();
    var attempts = 'attempts' in d && d.attempts ? number(d.attempts) : nil();
    var services = []; if ('services' in d && d.services)
	 { d.services.forEach(function(x){
	services.push(encode(x))});
	 services={t:108,v:services}; } else { services = nil() };
    var settings = []; if ('settings' in d && d.settings)
	 { d.settings.forEach(function(x){
	settings.push(encode(x))});
	 settings={t:108,v:settings}; } else { settings = nil() };
    var push = 'push' in d && d.push ? bin(d.push) : nil();
    var os = 'os' in d && d.os ? atom(d.os) : nil();
    var created = 'created' in d && d.created ? number(d.created) : nil();
    var last_online = 'last_online' in d && d.last_online ? number(d.last_online) : nil();
    return tuple(tup,client_id,dev_key,user_id,phone,token,type,sms_code,attempts,services,settings,
	push,os,created,last_online); }

function lenAuth() { return 15; }
function decAuth(d) {
    var r={}; r.tup = 'Auth';
    r.client_id = d && d.v[1] ? utf8_dec(d.v[1].v) : undefined;
    r.dev_key = d && d.v[2] ? utf8_dec(d.v[2].v) : undefined;
    r.user_id = d && d.v[3] ? utf8_dec(d.v[3].v) : undefined;
    r.phone = d && d.v[4] ? utf8_dec(d.v[4].v) : undefined;
    r.token = d && d.v[5] ? utf8_dec(d.v[5].v) : undefined;
    r.type = d && d.v[6] ? d.v[6].v : undefined;
    r.sms_code = d && d.v[7] ? utf8_dec(d.v[7].v) : undefined;
    r.attempts = d && d.v[8] ? d.v[8].v : undefined;
    r.services = [];
	 (d && d.v[9] && d.v[9].v) ?
	 d.v[9].v.forEach(function(x){r.services.push(decode(x))}) :
	 r.services = undefined;
    r.settings = [];
	 (d && d.v[10] && d.v[10].v) ?
	 d.v[10].v.forEach(function(x){r.settings.push(decode(x))}) :
	 r.settings = undefined;
    r.push = d && d.v[11] ? utf8_dec(d.v[11].v) : undefined;
    r.os = d && d.v[12] ? decode(d.v[12]) : undefined;
    r.created = d && d.v[13] ? d.v[13].v : undefined;
    r.last_online = d && d.v[14] ? d.v[14].v : undefined;
    return clean(r); }

function encRoster(d) {
    var tup = atom('Roster');
    var id = 'id' in d && d.id ? number(d.id) : nil();
    var names = 'names' in d && d.names ? bin(d.names) : nil();
    var surnames = 'surnames' in d && d.surnames ? bin(d.surnames) : nil();
    var email = 'email' in d && d.email ? bin(d.email) : nil();
    var nick = 'nick' in d && d.nick ? bin(d.nick) : nil();
    var userlist = []; if ('userlist' in d && d.userlist)
	 { d.userlist.forEach(function(x){
	userlist.push(encode(x))});
	 userlist={t:108,v:userlist}; } else { userlist = nil() };
    var roomlist = []; if ('roomlist' in d && d.roomlist)
	 { d.roomlist.forEach(function(x){
	roomlist.push(encode(x))});
	 roomlist={t:108,v:roomlist}; } else { roomlist = nil() };
    var favorite = []; if ('favorite' in d && d.favorite)
	 { d.favorite.forEach(function(x){
	favorite.push(encode(x))});
	 favorite={t:108,v:favorite}; } else { favorite = nil() };
    var tags = []; if ('tags' in d && d.tags)
	 { d.tags.forEach(function(x){
	tags.push(encode(x))});
	 tags={t:108,v:tags}; } else { tags = nil() };
    var phone = 'phone' in d && d.phone ? bin(d.phone) : nil();
    var avatar = 'avatar' in d && d.avatar ? bin(d.avatar) : nil();
    var update = 'update' in d && d.update ? number(d.update) : nil();
    var status = 'status' in d && d.status ? atom(d.status) : nil();
    return tuple(tup,id,names,surnames,email,nick,userlist,roomlist,favorite,tags,phone,
	avatar,update,status); }

function lenRoster() { return 14; }
function decRoster(d) {
    var r={}; r.tup = 'Roster';
    r.id = d && d.v[1] ? d.v[1].v : undefined;
    r.names = d && d.v[2] ? utf8_dec(d.v[2].v) : undefined;
    r.surnames = d && d.v[3] ? utf8_dec(d.v[3].v) : undefined;
    r.email = d && d.v[4] ? utf8_dec(d.v[4].v) : undefined;
    r.nick = d && d.v[5] ? utf8_dec(d.v[5].v) : undefined;
    r.userlist = [];
	 (d && d.v[6] && d.v[6].v) ?
	 d.v[6].v.forEach(function(x){r.userlist.push(decode(x))}) :
	 r.userlist = undefined;
    r.roomlist = [];
	 (d && d.v[7] && d.v[7].v) ?
	 d.v[7].v.forEach(function(x){r.roomlist.push(decode(x))}) :
	 r.roomlist = undefined;
    r.favorite = [];
	 (d && d.v[8] && d.v[8].v) ?
	 d.v[8].v.forEach(function(x){r.favorite.push(decode(x))}) :
	 r.favorite = undefined;
    r.tags = [];
	 (d && d.v[9] && d.v[9].v) ?
	 d.v[9].v.forEach(function(x){r.tags.push(decode(x))}) :
	 r.tags = undefined;
    r.phone = d && d.v[10] ? utf8_dec(d.v[10].v) : undefined;
    r.avatar = d && d.v[11] ? utf8_dec(d.v[11].v) : undefined;
    r.update = d && d.v[12] ? d.v[12].v : undefined;
    r.status = d && d.v[13] ? decode(d.v[13]) : undefined;
    return clean(r); }

function encProfile(d) {
    var tup = atom('Profile');
    var phone = 'phone' in d && d.phone ? bin(d.phone) : nil();
    var services = []; if ('services' in d && d.services)
	 { d.services.forEach(function(x){
	services.push(encode(x))});
	 services={t:108,v:services}; } else { services = nil() };
    var rosters = []; if ('rosters' in d && d.rosters)
	 { d.rosters.forEach(function(x){
	rosters.push(encode(x))});
	 rosters={t:108,v:rosters}; } else { rosters = nil() };
    var settings = []; if ('settings' in d && d.settings)
	 { d.settings.forEach(function(x){
	settings.push(encode(x))});
	 settings={t:108,v:settings}; } else { settings = nil() };
    var update = 'update' in d && d.update ? number(d.update) : nil();
    var balance = 'balance' in d && d.balance ? number(d.balance) : nil();
    var presence = 'presence' in d && d.presence ? atom(d.presence) : nil();
    var status = 'status' in d && d.status ? atom(d.status) : nil();
    return tuple(tup,phone,services,rosters,settings,update,balance,presence,status); }

function lenProfile() { return 9; }
function decProfile(d) {
    var r={}; r.tup = 'Profile';
    r.phone = d && d.v[1] ? utf8_dec(d.v[1].v) : undefined;
    r.services = [];
	 (d && d.v[2] && d.v[2].v) ?
	 d.v[2].v.forEach(function(x){r.services.push(decode(x))}) :
	 r.services = undefined;
    r.rosters = [];
	 (d && d.v[3] && d.v[3].v) ?
	 d.v[3].v.forEach(function(x){r.rosters.push(decode(x))}) :
	 r.rosters = undefined;
    r.settings = [];
	 (d && d.v[4] && d.v[4].v) ?
	 d.v[4].v.forEach(function(x){r.settings.push(decode(x))}) :
	 r.settings = undefined;
    r.update = d && d.v[5] ? d.v[5].v : undefined;
    r.balance = d && d.v[6] ? d.v[6].v : undefined;
    r.presence = d && d.v[7] ? decode(d.v[7]) : undefined;
    r.status = d && d.v[8] ? decode(d.v[8]) : undefined;
    return clean(r); }

function encLoc(d) {
    var tup = atom('Loc');
    var x = 'x' in d && d.x ? bin(d.x) : nil();
    var y = 'y' in d && d.y ? bin(d.y) : nil();
    var place_id = 'place_id' in d && d.place_id ? bin(d.place_id) : nil();
    return tuple(tup,x,y,place_id); }

function lenLoc() { return 4; }
function decLoc(d) {
    var r={}; r.tup = 'Loc';
    r.x = d && d.v[1] ? utf8_dec(d.v[1].v) : undefined;
    r.y = d && d.v[2] ? utf8_dec(d.v[2].v) : undefined;
    r.place_id = d && d.v[3] ? utf8_dec(d.v[3].v) : undefined;
    return clean(r); }

function encFriend(d) {
    var tup = atom('Friend');
    var phone_id = 'phone_id' in d && d.phone_id ? bin(d.phone_id) : nil();
    var friend_id = 'friend_id' in d && d.friend_id ? bin(d.friend_id) : nil();
    var settings = []; if ('settings' in d && d.settings)
	 { d.settings.forEach(function(x){
	settings.push(encode(x))});
	 settings={t:108,v:settings}; } else { settings = nil() };
    var status = 'status' in d && d.status ? atom(d.status) : nil();
    return tuple(tup,phone_id,friend_id,settings,status); }

function lenFriend() { return 5; }
function decFriend(d) {
    var r={}; r.tup = 'Friend';
    r.phone_id = d && d.v[1] ? utf8_dec(d.v[1].v) : undefined;
    r.friend_id = d && d.v[2] ? utf8_dec(d.v[2].v) : undefined;
    r.settings = [];
	 (d && d.v[3] && d.v[3].v) ?
	 d.v[3].v.forEach(function(x){r.settings.push(decode(x))}) :
	 r.settings = undefined;
    r.status = d && d.v[4] ? decode(d.v[4]) : undefined;
    return clean(r); }

function encCallMember(d) {
    var tup = atom('CallMember');
    var id = 'id' in d && d.id ? number(d.id) : nil();
    var feed_id = 'feed_id' in d && d.feed_id ? bin(d.feed_id) : nil();
    var prev = 'prev' in d && d.prev ? number(d.prev) : nil();
    var next = 'next' in d && d.next ? number(d.next) : nil();
    var contact = 'contact' in d && d.contact ? encode(d.contact) : nil();
    var start = 'start' in d && d.start ? number(d.start) : nil();
    var stop = 'stop' in d && d.stop ? number(d.stop) : nil();
    var type = 'type' in d && d.type ? atom(d.type) : nil();
    var desc = 'desc' in d && d.desc ? bin(d.desc) : nil();
    var tariff = 'tariff' in d && d.tariff ? bin(d.tariff) : nil();
    var bill = 'bill' in d && d.bill ? number(d.bill) : nil();
    var duration = 'duration' in d && d.duration ? number(d.duration) : nil();
    var status = 'status' in d && d.status ? atom(d.status) : nil();
    return tuple(tup,id,feed_id,prev,next,contact,start,stop,type,desc,tariff,
	bill,duration,status); }

function lenCallMember() { return 14; }
function decCallMember(d) {
    var r={}; r.tup = 'CallMember';
    r.id = d && d.v[1] ? d.v[1].v : undefined;
    r.feed_id = d && d.v[2] ? utf8_dec(d.v[2].v) : undefined;
    r.prev = d && d.v[3] ? d.v[3].v : undefined;
    r.next = d && d.v[4] ? d.v[4].v : undefined;
    r.contact = d && d.v[5] ? decode(d.v[5]) : undefined;
    r.start = d && d.v[6] ? d.v[6].v : undefined;
    r.stop = d && d.v[7] ? d.v[7].v : undefined;
    r.type = d && d.v[8] ? decode(d.v[8]) : undefined;
    r.desc = d && d.v[9] ? utf8_dec(d.v[9].v) : undefined;
    r.tariff = d && d.v[10] ? utf8_dec(d.v[10].v) : undefined;
    r.bill = d && d.v[11] ? d.v[11].v : undefined;
    r.duration = d && d.v[12] ? d.v[12].v : undefined;
    r.status = d && d.v[13] ? decode(d.v[13]) : undefined;
    return clean(r); }

function encCall(d) {
    var tup = atom('Call');
    var id = 'id' in d && d.id ? bin(d.id) : nil();
    var from = 'from' in d && d.from ? bin(d.from) : nil();
    var members = []; if ('members' in d && d.members)
	 { d.members.forEach(function(x){
	members.push(encode(x))});
	 members={t:108,v:members}; } else { members = nil() };
    var start = 'start' in d && d.start ? number(d.start) : nil();
    var stop = 'stop' in d && d.stop ? number(d.stop) : nil();
    var vox_url = 'vox_url' in d && d.vox_url ? bin(d.vox_url) : nil();
    var status = 'status' in d && d.status ? atom(d.status) : nil();
    return tuple(tup,id,from,members,start,stop,vox_url,status); }

function lenCall() { return 8; }
function decCall(d) {
    var r={}; r.tup = 'Call';
    r.id = d && d.v[1] ? utf8_dec(d.v[1].v) : undefined;
    r.from = d && d.v[2] ? utf8_dec(d.v[2].v) : undefined;
    r.members = [];
	 (d && d.v[3] && d.v[3].v) ?
	 d.v[3].v.forEach(function(x){r.members.push(decode(x))}) :
	 r.members = undefined;
    r.start = d && d.v[4] ? d.v[4].v : undefined;
    r.stop = d && d.v[5] ? d.v[5].v : undefined;
    r.vox_url = d && d.v[6] ? utf8_dec(d.v[6].v) : undefined;
    r.status = d && d.v[7] ? decode(d.v[7]) : undefined;
    return clean(r); }

function encact(d) {
    var tup = atom('act');
    var name = 'name' in d && d.name ? bin(d.name) : nil();
    var data = 'data' in d && d.data ? encode(d.data) : nil();
    return tuple(tup,name,data); }

function lenact() { return 3; }
function decact(d) {
    var r={}; r.tup = 'act';
    r.name = d && d.v[1] ? utf8_dec(d.v[1].v) : undefined;
    r.data = d && d.v[2] ? decode(d.v[2]) : undefined;
    return clean(r); }

function encJob(d) {
    var tup = atom('Job');
    var id = 'id' in d && d.id ? number(d.id) : nil();
    var feed_id = 'feed_id' in d && d.feed_id ? encode(d.feed_id) : nil();
    var prev = 'prev' in d && d.prev ? number(d.prev) : nil();
    var next = 'next' in d && d.next ? number(d.next) : nil();
    var context = 'context' in d && d.context ? encode(d.context) : nil();
    var proc = 'proc' in d && d.proc ? encode(d.proc) : nil();
    var time = 'time' in d && d.time ? number(d.time) : nil();
    var data = []; if ('data' in d && d.data)
	 { d.data.forEach(function(x){
	data.push(encode(x))});
	 data={t:108,v:data}; } else { data = nil() };
    var events = []; if ('events' in d && d.events)
	 { d.events.forEach(function(x){
	events.push(encode(x))});
	 events={t:108,v:events}; } else { events = nil() };
    var settings = []; if ('settings' in d && d.settings)
	 { d.settings.forEach(function(x){
	settings.push(encode(x))});
	 settings={t:108,v:settings}; } else { settings = nil() };
    var status = 'status' in d && d.status ? atom(d.status) : nil();
    return tuple(tup,id,feed_id,prev,next,context,proc,time,data,events,settings,status); }

function lenJob() { return 12; }
function decJob(d) {
    var r={}; r.tup = 'Job';
    r.id = d && d.v[1] ? d.v[1].v : undefined;
    r.feed_id = d && d.v[2] ? decode(d.v[2]) : undefined;
    r.prev = d && d.v[3] ? d.v[3].v : undefined;
    r.next = d && d.v[4] ? d.v[4].v : undefined;
    r.context = d && d.v[5] ? decode(d.v[5]) : undefined;
    r.proc = d && d.v[6] ? decode(d.v[6]) : undefined;
    r.time = d && d.v[7] ? d.v[7].v : undefined;
    r.data = [];
	 (d && d.v[8] && d.v[8].v) ?
	 d.v[8].v.forEach(function(x){r.data.push(decode(x))}) :
	 r.data = undefined;
    r.events = [];
	 (d && d.v[9] && d.v[9].v) ?
	 d.v[9].v.forEach(function(x){r.events.push(decode(x))}) :
	 r.events = undefined;
    r.settings = [];
	 (d && d.v[10] && d.v[10].v) ?
	 d.v[10].v.forEach(function(x){r.settings.push(decode(x))}) :
	 r.settings = undefined;
    r.status = d && d.v[11] ? decode(d.v[11]) : undefined;
    return clean(r); }

function encHistory(d) {
    var tup = atom('History');
    var roster_id = 'roster_id' in d && d.roster_id ? bin(d.roster_id) : nil();
    var feed = 'feed' in d && d.feed ? encode(d.feed) : nil();
    var size = 'size' in d && d.size ? number(d.size) : nil();
    var entity_id = 'entity_id' in d && d.entity_id ? number(d.entity_id) : nil();
    var data = []; if ('data' in d && d.data)
	 { d.data.forEach(function(x){
	data.push(encode(x))});
	 data={t:108,v:data}; } else { data = nil() };
    var status = 'status' in d && d.status ? atom(d.status) : nil();
    return tuple(tup,roster_id,feed,size,entity_id,data,status); }

function lenHistory() { return 7; }
function decHistory(d) {
    var r={}; r.tup = 'History';
    r.roster_id = d && d.v[1] ? utf8_dec(d.v[1].v) : undefined;
    r.feed = d && d.v[2] ? decode(d.v[2]) : undefined;
    r.size = d && d.v[3] ? d.v[3].v : undefined;
    r.entity_id = d && d.v[4] ? d.v[4].v : undefined;
    r.data = [];
	 (d && d.v[5] && d.v[5].v) ?
	 d.v[5].v.forEach(function(x){r.data.push(decode(x))}) :
	 r.data = undefined;
    r.status = d && d.v[6] ? decode(d.v[6]) : undefined;
    return clean(r); }

function encSchedule(d) {
    var tup = atom('Schedule');
    var id = 'id' in d && d.id ? number(d.id) : nil();
    var proc = 'proc' in d && d.proc ? number(d.proc) : nil();
    var data = []; if ('data' in d && d.data)
	 { d.data.forEach(function(x){
	data.push(encode(x))});
	 data={t:108,v:data}; } else { data = nil() };
    var state = 'state' in d && d.state ? encode(d.state) : nil();
    return tuple(tup,id,proc,data,state); }

function lenSchedule() { return 5; }
function decSchedule(d) {
    var r={}; r.tup = 'Schedule';
    r.id = d && d.v[1] ? d.v[1].v : undefined;
    r.proc = d && d.v[2] ? d.v[2].v : undefined;
    r.data = [];
	 (d && d.v[3] && d.v[3].v) ?
	 d.v[3].v.forEach(function(x){r.data.push(decode(x))}) :
	 r.data = undefined;
    r.state = d && d.v[4] ? decode(d.v[4].v) : undefined;
    return clean(r); }

function encIndex(d) {
    var tup = atom('Index');
    var id = 'id' in d && d.id ? encode(d.id) : nil();
    var roster = []; if ('roster' in d && d.roster)
	 { d.roster.forEach(function(x){
	roster.push(encode(x))});
	 roster={t:108,v:roster}; } else { roster = nil() };
    return tuple(tup,id,roster); }

function lenIndex() { return 3; }
function decIndex(d) {
    var r={}; r.tup = 'Index';
    r.id = d && d.v[1] ? decode(d.v[1].v) : undefined;
    r.roster = [];
	 (d && d.v[2] && d.v[2].v) ?
	 d.v[2].v.forEach(function(x){r.roster.push(decode(x))}) :
	 r.roster = undefined;
    return clean(r); }

function encWhitelist(d) {
    var tup = atom('Whitelist');
    var phone = 'phone' in d && d.phone ? bin(d.phone) : nil();
    var created = 'created' in d && d.created ? number(d.created) : nil();
    return tuple(tup,phone,created); }

function lenWhitelist() { return 3; }
function decWhitelist(d) {
    var r={}; r.tup = 'Whitelist';
    r.phone = d && d.v[1] ? utf8_dec(d.v[1].v) : undefined;
    r.created = d && d.v[2] ? d.v[2].v : undefined;
    return clean(r); }

function encerror(d) {
    var tup = atom('error');
    var code = 'code' in d && d.code ? bin(d.code) : nil();
    return tuple(tup,code); }

function lenerror() { return 2; }
function decerror(d) {
    var r={}; r.tup = 'error';
    r.code = d && d.v[1] ? utf8_dec(d.v[1].v) : undefined;
    return clean(r); }

function encok(d) {
    var tup = atom('ok');
    var code = 'code' in d && d.code ? bin(d.code) : nil();
    return tuple(tup,code); }

function lenok() { return 2; }
function decok(d) {
    var r={}; r.tup = 'ok';
    r.code = d && d.v[1] ? utf8_dec(d.v[1].v) : undefined;
    return clean(r); }

function encerror2(d) {
    var tup = atom('error2');
    var code = 'code' in d && d.code ? atom(d.code) : nil();
    var src = 'src' in d && d.src ? encode(d.src) : nil();
    return tuple(tup,code,src); }

function lenerror2() { return 3; }
function decerror2(d) {
    var r={}; r.tup = 'error2';
    r.code = d && d.v[1] ? d.v[1].v : undefined;
    r.src = d && d.v[2] ? decode(d.v[2]) : undefined;
    return clean(r); }

function encok2(d) {
    var tup = atom('ok2');
    var code = 'code' in d && d.code ? atom(d.code) : nil();
    var src = 'src' in d && d.src ? encode(d.src) : nil();
    return tuple(tup,code,src); }

function lenok2() { return 3; }
function decok2(d) {
    var r={}; r.tup = 'ok2';
    r.code = d && d.v[1] ? d.v[1].v : undefined;
    r.src = d && d.v[2] ? decode(d.v[2]) : undefined;
    return clean(r); }

function encio(d) {
    var tup = atom('io');
    var code = 'code' in d && d.code ? encode(d.code) : nil();
    var data = 'data' in d && d.data ? encode(d.data) : nil();
    return tuple(tup,code,data); }

function lenio() { return 3; }
function decio(d) {
    var r={}; r.tup = 'io';
    r.code = d && d.v[1] ? decode(d.v[1]) : undefined;
    r.data = d && d.v[2] ? decode(d.v[2]) : undefined;
    return clean(r); }

function encerrors(d) {
    var tup = atom('errors');
    var code = []; if ('code' in d && d.code)
	 { d.code.forEach(function(x){
	code.push(encode(x))});
	 code={t:108,v:code}; } else { code = nil() };
    var data = 'data' in d && d.data ? encode(d.data) : nil();
    return tuple(tup,code,data); }

function lenerrors() { return 3; }
function decerrors(d) {
    var r={}; r.tup = 'errors';
    r.code = [];
	 (d && d.v[1] && d.v[1].v) ?
	 d.v[1].v.forEach(function(x){r.code.push(decode(x))}) :
	 r.code = undefined;
    r.data = d && d.v[2] ? decode(d.v[2].v) : undefined;
    return clean(r); }

function encPushService(d) {
    var tup = atom('PushService');
    var recipients = []; if ('recipients' in d && d.recipients)
	 { d.recipients.forEach(function(x){
	recipients.push(encode(x))});
	 recipients={t:108,v:recipients}; } else { recipients = nil() };
    var id = 'id' in d && d.id ? bin(d.id) : nil();
    var ttl = 'ttl' in d && d.ttl ? number(d.ttl) : nil();
    var module = 'module' in d && d.module ? bin(d.module) : nil();
    var priority = 'priority' in d && d.priority ? bin(d.priority) : nil();
    var payload = 'payload' in d && d.payload ? bin(d.payload) : nil();
    return tuple(tup,recipients,id,ttl,module,priority,payload); }

function lenPushService() { return 7; }
function decPushService(d) {
    var r={}; r.tup = 'PushService';
    r.recipients = [];
	 (d && d.v[1] && d.v[1].v) ?
	 d.v[1].v.forEach(function(x){r.recipients.push(decode(x))}) :
	 r.recipients = undefined;
    r.id = d && d.v[2] ? utf8_dec(d.v[2].v) : undefined;
    r.ttl = d && d.v[3] ? d.v[3].v : undefined;
    r.module = d && d.v[4] ? utf8_dec(d.v[4].v) : undefined;
    r.priority = d && d.v[5] ? utf8_dec(d.v[5].v) : undefined;
    r.payload = d && d.v[6] ? utf8_dec(d.v[6].v) : undefined;
    return clean(r); }

function encPublishService(d) {
    var tup = atom('PublishService');
    var message = 'message' in d && d.message ? bin(d.message) : nil();
    var topic = 'topic' in d && d.topic ? bin(d.topic) : nil();
    var qos = 'qos' in d && d.qos ? number(d.qos) : nil();
    return tuple(tup,message,topic,qos); }

function lenPublishService() { return 4; }
function decPublishService(d) {
    var r={}; r.tup = 'PublishService';
    r.message = d && d.v[1] ? utf8_dec(d.v[1].v) : undefined;
    r.topic = d && d.v[2] ? utf8_dec(d.v[2].v) : undefined;
    r.qos = d && d.v[3] ? d.v[3].v : undefined;
    return clean(r); }

function encTest(d) {
    var tup = atom('Test');
    var type = 'type' in d && d.type ? atom(d.type) : nil();
    var count = 'count' in d && d.count ? number(d.count) : nil();
    return tuple(tup,type,count); }

function lenTest() { return 3; }
function decTest(d) {
    var r={}; r.tup = 'Test';
    r.type = d && d.v[1] ? decode(d.v[1]) : undefined;
    r.count = d && d.v[2] ? d.v[2].v : undefined;
    return clean(r); }

