import QtQuick 2.15
import QtMultimedia 5.15
Audio{
    id: mediaPlayer
    enum PlayMode{
        REPEATSINGLEPLAY=0,//单曲循环
        LOOPPLAY=1,//列表循环
        RANDOMPLAY=2,//随机播放
        PLAYLISTPLAY=3//列表播放
    }
    property int playModeCount: 4
    property int playModeStates:QCMusicPlayer.PlayMode.REPEATSINGLEPLAY

    volume: 0.5 //初始默认音量
    function setPlayMode(){
        playModeStates=(playModeStates+1) % playModeCount        //0-3
    }

    onPlaybackStateChanged: {
        //为停止状态且已播放位置等于时长
        if(playbackState===Audio.StoppedState&&duration===position){
            autoNextMusic()
        }
    }

    function playPauseMusic() {
            if (source === "") return;

            if (mediaPlayer.playbackState === Audio.PlayingState) {
                mediaPlayer.pause();
            } else if (mediaPlayer.playbackState === Audio.StoppedState || mediaPlayer.playbackState === Audio.PausedState) {
                mediaPlayer.play();
            }
        }
    function preMusic(){
        if(musicres.playList.length===0)return

        let newIndex=musicres.currentMusicIndex-1
        if(newIndex<0){
            newIndex=musicres.playList.length-1        //从最后一首开始播放
        }
        loadAndPlay(newIndex)
    }
    function nextMusic(){
        if(musicres.playList.length===0)return
        let newIndex=musicres.currentMusicIndex+1
        if(newIndex>=musicres.playList.length){
            newIndex=0                                //从第一首开始播放
        }
        if(playModeStates===QCMusicPlayer.PlayMode.RANDOMPLAY){
            do{
                newIndex=Math.floor(Math.random()*musicres.playList.length)
            }while(musicres.currentMusicIndex===newIndex)
        }

        loadAndPlay(newIndex)
    }
    //根据index获取歌曲信息和url  然后传值给thismusicinfo(根据其中的url播放) 并更新currentMusicIndex
    function loadAndPlay(index){
        const musicInfo=musicres.playList[index]
        musicres.getMusicUrl({id:musicInfo.id,callBack:res=>{
            musicInfo.url=res.url
            musicres.currentMusicIndex=index
            musicres.thisMusicInfo=musicInfo
            play()
            }
        })
    }

    function autoNextMusic(){
        switch(musicPlayer.playModeStates){
        case QCMusicPlayer.PlayMode.REPEATSINGLEPLAY:
            play()
            break
        case QCMusicPlayer.PlayMode.LOOPPLAY:
            nextMusic()
            break
        case QCMusicPlayer.PlayMode.RANDOMPLAY:
            nextMusic()
            break
        case QCMusicPlayer.PlayMode.PLAYLISTPLAY:
            if(musicres.playList.length-1 === musicres.currentMusicIndex)
            {
                //已经是最后一首 什么都不做
            }else{
                nextMusic()
            }

            break
        }
    }
}
