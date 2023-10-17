package org.demo;

import org.demo.Movie;
import org.eclipse.microprofile.reactive.messaging.Incoming;
import org.jboss.logging.Logger;
import jakarta.enterprise.context.ApplicationScoped;


@ApplicationScoped
public class ConsumedMovieResource {

    private static final Logger LOGGER =  Logger.getLogger(ConsumedMovieResource.class);

    @Incoming("movies")
    public void receive(Movie movie) {
        if(movie == null){
            LOGGER.error( "ERROR", new NullPointerException("UNKNOWN DATA, CANNOT PROCESS!!")); 
            return;
        }
        LOGGER.infof("Received movie: %s (%d)", movie.getTitle(), movie.getYear());
       
    }

}