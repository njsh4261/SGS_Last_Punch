var stompClient = null;
var presenceList = document.getElementById('presenceList');

function setConnected(connected) {
    document.getElementById('connect').disabled = connected;
    document.getElementById('disconnect').disabled = !connected;
    document.getElementById('presenceDiv').style.visibility = connected ? 'visible' : 'hidden';
    presenceList.innerHTML = '';
}

function connect() {
    var socket = new SockJS('/ws/presence');
    const workspaceId = document.getElementById('workspaceId').value;
    stompClient = Stomp.over(socket);
    stompClient.connect({}, function(frame) {
        setConnected(true);
        console.log('Connected: ' + frame);

        // subscribe messages for current workspace
        stompClient.subscribe(
            '/topic/workspace.' + workspaceId,
            function(message) {
                updatePresence(JSON.parse(message.body));
            }
        );

        getPresenceList();
        stompClient.send("/app/update", {},
            JSON.stringify({
                'workspaceId': document.getElementById('workspaceId').value,
                'userId': document.getElementById('userId').value,
                'userStatus': 'ONLINE'
            })
        );
    });
}

function disconnect() {
    if(stompClient != null) {
        stompClient.disconnect();
    }
    setConnected(false);
    console.log('Disconnected');
}

function sendMessage() {
    stompClient.send("/app/update", {},
        JSON.stringify({
            'workspaceId': document.getElementById('workspaceId').value,
            'userId': document.getElementById('userId').value,
            'userStatus': document.getElementById('userStatus').value
        })
    );
}

function getPresenceList(){
    const workspaceId = document.getElementById('workspaceId').value;
    $.ajax({
        type: 'GET',
        url:'http://localhost:8084/presence/' + workspaceId,
        contentType : 'application/json; charset=utf-8',
    }).done(function(res) {
        console.log('GET /presence/' + workspaceId + ': ' + JSON.stringify(res))

        res.data.forEach(presence => {
            updatePresence(presence);
        });
    }).fail(function(err) {
        console.log('fail to get presence information!')
    });
}

function updatePresence(presence) {
    var p = document.getElementById('user-' + presence.userId);
    if(p){
        while(p.lastChild) {
            p.removeChild(p.lastChild);
        }
        append(p, presence);
    }
    else{
        var n = document.createElement('p');
        n.style.wordBreak = 'break-all';
        n.setAttribute('id', 'user-' + presence.userId)
        append(n, presence);
    }
}

function append(p, newElement){
    p.appendChild(
        document.createTextNode(
            "[userId: " + newElement.userId + ", status: " + newElement.userStatus + "]"
        )
    );
    presenceList.appendChild(p);
}
