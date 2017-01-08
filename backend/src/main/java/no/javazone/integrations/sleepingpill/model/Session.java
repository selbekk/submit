package no.javazone.integrations.sleepingpill.model;

import java.util.List;

public class Session {

    public String sessionId;
    public String conferenceId;
    public String status;
    public List<Speaker> speakers;
    public SessionData data;

    public String getTitle() {
        return data.title != null ? data.title.value : null;
    }

    public String getAbstract() {
        return data.theAbstract != null ? data.theAbstract.value : null;
    }

    public String getIntendedAudience() {
        return data.intendedAudience != null ? data.intendedAudience.value : null;
    }

    public String getFormat() {
        return data.format != null ? data.format.value : null;
    }

    public String getLanguage() {
        return data.language != null ? data.language.value : null;
    }

    public String getPublished() {
        return data.published != null ? data.published.value : null;
    }

    public List<String> getKeywords() {
        return data.keywords != null ? data.keywords.value : null;
    }

    public String getOutline() {
        return data.outline != null ? data.outline.value : null;
    }

    @Override
    public String toString() {
        return "Session{" +
                "sessionId='" + sessionId + '\'' +
                ", conferenceId='" + conferenceId + '\'' +
                ", status='" + status + '\'' +
                ", speakers=" + speakers +
                ", data=" + data +
                '}';
    }
}
