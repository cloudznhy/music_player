import QtQuick 2.15

Item {
    property var playList:[]  //当前播放列表（存储所有歌曲信息）
    property int currentMusicIndex: -1//现在播放的音乐序号
    //播放的音乐信息
    property var thisMusicInfo: {
        "id":"",
        "name":"",
        "artist":"",
        "album":"",
        "coverImg":"",
        "url":"",
        "allTime":"",
    }
    property ListModel thisPlayMusiclyric: ListModel{}

    onThisMusicInfoChanged: {
        //console.log(JSON.stringify(thisMusicInfo) )
        var lyricCallback=res=>{
            //console.log(JSON.stringify(res))
            thisPlayMusiclyric.clear()
            thisPlayMusiclyric.append(res)
        }
        if(thisMusicInfo.id){
            getLyric({id:thisMusicInfo.id,callBack:lyricCallback})
        }
    }

    //最新音乐获取
    function getNewMusic(obj) {
            var xhr = new XMLHttpRequest()
            var type = obj.type || "0"
            var callBack = obj.callBack || (()=>{})
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    if (xhr.status === 200) {
                        var res = JSON.parse(xhr.responseText).data
                        res = res.map(obj=> {
                                    return {
                                        id: obj.id,
                                        name: obj.name,
                                        artist: obj.artists.map(ar => ar.name).join("/ "),
                                        album: obj.album.name,
                                        coverImg: obj.album.picUrl,
                                        url: "",
                                        allTime: setTime(obj.duration)
                                    }
                                 })
                        callBack({data:res,status:xhr.status})  //后面res.data是因为这里不同
                    } else {
                        callBack({data:null,status:xhr.status})
                        console.error("Request failed: " + xhr.status); // 请求失败
                    }
                }
            };
            xhr.open("GET", "http://localhost:3000/top/song?type=" + type); // 发起 GET 请求
            xhr.send(); // 发送请求
        }
    //歌单获取
    function getMusicPlayList(obj){
        var xhr = new XMLHttpRequest()
        var cat = obj.cat || "全部"
        var limit = obj.limit || "hot"
        var order = obj.order || "40"
        var callBack = obj.callBack || (()=>{})
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var res = JSON.parse(xhr.responseText).playlists
                    res = res.map(obj=> {
                                return {
                                    id: obj.id,
                                    name: obj.name,
                                    description: obj.description,
                                    coverImg: obj.coverImgUrl.substring(0,obj.coverImgUrl.lastIndexOf("thumbnail")),
                                    url: "",
                                    allTime: setTime(obj.duration)
                                }
                             })
                    callBack({data:res,status:xhr.status})
                } else {
                    callBack({data:null,status:xhr.status})
                    console.error("Request failed: " + xhr.status); // 请求失败
                }
            }
        };
        xhr.open("GET", "http://localhost:3000/top/playlist?cat="+cat+"&limit="+60+"&order="+order,true); // 发起 GET 请求
        xhr.send(); // 发送请求
    }

     //精品歌单获取 作为歌单界面的头部信息
    function getHeaderInfo(obj){
        var xhr = new XMLHttpRequest()
        var cat = obj.cat || "全部"
        var limit = obj.limit || "hot"
        var callBack = obj.callBack || (()=>{})
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var res = JSON.parse(xhr.responseText).playlists
                    res = res.map(obj=> {
                                return {
                                    id: obj.id,
                                    name: obj.name,
                                    description: obj.description,
                                    coverImg: obj.coverImgUrl,
                                    url: "",
                                    allTime: setTime(obj.duration)
                                }
                             })
                    callBack({data:res,status:xhr.status})
                } else {
                    callBack({data:null,status:xhr.status})
                    console.error("Request failed: " + xhr.status); // 请求失败
                }
            }
        };
        xhr.open("GET", "http://localhost:3000/top/playlist/highquality?cat="+cat+"&limit="+5,true); // 发起 GET 请求
        xhr.send(); // 发送请求
    }

    //获取歌单详情
    function getMusicPlayListDetail(obj){
        var id=obj.id ||""
        var callBack = obj.callBack || (()=>{})
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var res = JSON.parse(xhr.responseText).playlist
                    res = {
                        id: res.id,
                        name: res.name,
                        description: res.description,
                        coverImg: res.coverImgUrl/*.split('?')[0]*/,
                        trackIds:res.trackIds.map(r =>{return r.id})
                    }

                    callBack(res)
                } else {
                    console.error("Request failed: " + xhr.status); // 请求失败
                }
            }
        };
        xhr.open("GET", "http://localhost:3000/playlist/detail?id="+id,true); // 发起 GET 请求
        xhr.send(); // 发送请求
    }
    //获取歌单的歌曲详情
    function getMusicDetail(obj){
        var ids=obj.ids ||""
        var callBack = obj.callBack || (()=>{})
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var res = JSON.parse(xhr.responseText).songs
                    res = res.map(obj=> {
                                return {
                                    id: obj.id,
                                    name: obj.name,
                                    artist: obj.ar.map(ar => ar.name).join("/ "),
                                    album: obj.al.name,
                                    coverImg: obj.al.picUrl,
                                    url: "",
                                    allTime: setTime(obj.dt)
                                }
                             })
                    callBack(res)
                } else {
                    console.error("Request failed: " + xhr.status); // 请求失败
                }
            }
        };
        xhr.open("GET", "http://localhost:3000/song/detail?ids="+ids,true); // 发起 GET 请求
        xhr.send(); // 发送请求
    }
    //获取音乐url
    function getMusicUrl(obj){
        var id=obj.id ||"0"
        var callBack = obj.callBack || (()=>{})
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var res = JSON.parse(xhr.responseText).data[0]
                    callBack(res)
                } else {
                    console.error("Request failed: " + xhr.status); // 请求失败
                }
            }
        };
        xhr.open("GET", "http://localhost:3000/song/url/v1?id="+id+"&level=jymaster",true); // 发起 GET 请求
        xhr.send(); // 发送请求
    }
    //获取搜索的歌曲
    function selectMusic(obj) {
        var xhr = new XMLHttpRequest();
        var keywords = obj.keywords || "0";
        var callBack = obj.callBack || (() => {});

        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    try {
                        const response = JSON.parse(xhr.responseText);
                        //console.log("Raw response:", response); // 调试：输出原始响应

                        // 检查 response.result 是否存在
                        if (!response.result || !response.result.songs) {
                            console.error("Invalid response format:", response);
                            callBack([]); // 返回空数组，避免后续错误
                            return;
                        }

                        var res = response.result.songs;
                        res = res.map(obj => {
                            return {
                                id: obj.id,
                                name: obj.name,
                                artist: obj.ar.map(ar => ar.name).join("/ "),
                                album: obj.al.name,
                                coverImg: obj.al.picUrl,
                                url: "",
                                allTime: setTime(obj.dt)
                            };
                        });
                        callBack(res);
                    } catch (e) {
                        console.error("JSON parse error:", e.message, "Response text:", xhr.responseText);
                        callBack([]); // 解析失败时返回空数组
                    }
                } else {
                    console.error("Request failed with status:", xhr.status, "Response:", xhr.responseText);
                    callBack([]); // 请求失败时返回空数组
                }
            }
        };

        var url = "http://localhost:3000/cloudsearch?keywords=" + encodeURIComponent(keywords);
        //console.log("Request URL:", url); // 调试：输出请求 URL
        xhr.open("GET", url, true);
        xhr.send();
    }
 //将时间从毫秒转为 00:00格式
    function setTime(time){
        var m=parseInt(time/1000/60)
        var s=parseInt(time/1000)%60

        m=m<10?"0"+m:m
        s=s<10?"0"+s:s
        return m+":"+s
    }
    //获取歌词
    function getLyric(obj) {
        var xhr = new XMLHttpRequest()
        var id = obj.id || "0"
        var callBack = obj.callBack || (()=>{})
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var res = JSON.parse(xhr.responseText)
                    var lrc=res.lrc.lyric
                    var lyric=null
                    if(res.hasOwnProperty("pureMusic")){
                        console.log("这是纯音乐")
                        lyric=parseLyric(lrc,"")
                    }else{
                        lyric=parseLyric(lrc,res.tlyric.lyric)
                    }

                    callBack(lyric)
                } else {
                    console.error("Request failed: " + xhr.status); // 请求失败
                }
            }
        };
        xhr.open("GET", "http://localhost:3000/lyric?id="+id,true); // 发起 GET 请求
        xhr.send(); // 发送请求
    }
    function parseLyric(lrc,tlrc){
        var i = 0
           lrc = lrc.split('\n')
           tlrc = tlrc.split('\n')

           try {
               if(Array.isArray(lrc)) {

                   for(i = 0; i < lrc.length;i++) {
                       if(!lrc[i]) continue
                       let t = lrc[i].match(/\[(.*?)\]\s*(.*)/)
                       let tim = t[1].split(':')
                       tim = parseInt(tim[0]) * 60*1000 + parseInt(parseFloat(tim[1])*1000)
                       lrc[i] = {tim: tim, lyric: t[2],tlrc: ""}
                   }

               }
               if(Array.isArray(tlrc)) {

                   for(i = 0; i < tlrc.length;i++) {
                       if(!tlrc[i]) continue
                       let t = tlrc[i].match(/\[(.*?)\]\s*(.*)/)
                       let tim = -1
                       if(!t) {
                           tlrc[i] = {tim: tim, lyric: ""}
                           continue
                       }
                       tim = t[1].split(':')
                       tim = parseInt(tim[0]) * 60*1000 + parseInt(parseFloat(tim[1])*1000)
                       tlrc[i] = {tim: tim, lyric: t[2]}
                   }

               }

               if(Array.isArray(tlrc))
               for(i = 0; i < lrc.length;i++) {
                   let index = tlrc.findIndex(r => lrc[i].tim === r.tim)
                   if(index !== -1) {
                       lrc[i].tlrc = tlrc[index].lyric
                   }
               }
           } catch(err) {
               console.log("歌词解析错误！" + err)
               for(i = 0; i < lrc.length;i++) {
                  lrc[i] = { "lyric": lrc[i],"tlrc": "",tim: 0 }
               }
           }

           lrc = lrc.filter(item => item.lyric)
           return lrc
    }
}
