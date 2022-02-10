var stompClient = null;

function setConnected(connected) {
    document.getElementById('connect').disabled = connected;
    document.getElementById('disconnect').disabled = !connected;
    document.getElementById('presenceDiv').style.visibility = connected ? 'visible' : 'hidden';
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

        // update status of current user
        stompClient.send("/app/update", {},
        JSON.stringify({
            'workspaceId': document.getElementById('workspaceId').value,
            'userId': document.getElementById('userId').value,
            'status': 'ONLINE'
            })
        );

        getPresenceList();
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
            'status': document.getElementById('status').value
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

        // initialize presence list
        var presenceList = document.getElementById('presenceList');
        presenceList.innerHTML = '';

        // print new list
        res.data.forEach(presence => {
            addToList(presenceList, presence);
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
        p.appendChild(
            document.createTextNode(
                "[userId: " + presence.userId + ", status: " + presence.status + "]"
            )
        );
    }
    else{
        addToList(document.getElementById('presenceList'), presence);
    }
}

function addToList(list, newElement){
    var p = document.createElement('p');
    p.style.wordBreak = 'break-all';
    p.setAttribute('id', 'user-' + newElement.userId)
    p.appendChild(
        document.createTextNode(
            "[userId: " + newElement.userId + ", status: " + newElement.status + "]"
        )
    );
    list.appendChild(p);
}