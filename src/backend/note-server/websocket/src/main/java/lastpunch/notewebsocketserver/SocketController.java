package lastpunch.notewebsocketserver;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.stereotype.Controller;

@Controller
public class SocketController {
    
    @MessageMapping("note")
    public Flux<> feedMarketData(MarketDataRequest marketDataRequest) {
        return marketDataRepository.getAll(marketDataRequest.getStock());
    }
}