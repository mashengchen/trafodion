package org.trafodion.wms.server.stats;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.Arrays;
import java.io.File;
//
final class PStatsMemInfo extends PStatsMemoryMonitor {
    public PStatsMemoryUsage monitor() throws IOException {
        BufferedReader r = new BufferedReader(new FileReader("/proc/meminfo"));
        try {
            long[] values = new long[4];
            Arrays.fill(values,-1);

            String line;
            while((line=r.readLine())!=null) {
                for( int i=0; i<HEADERS.length; i++ ) {
                    if(line.startsWith(HEADERS[i])) {
                        // found a line that we care about
                        String s = line.substring(HEADERS[i].length()).trim();

                        // trim off the suffix, if any
                        Suffix suffix = Suffix.find(s);
                        s = s.substring(0,s.length()-suffix.name.length()).trim();

                        try {
                            values[i] = Long.parseLong(s)*suffix.multiplier;
                        } catch (NumberFormatException e) {
                            throw new IOException("Failed to parse: '"+s+"' out of '"+line+"'");
                        }
                        break;
                    }
                }
            }

            return new PStatsMemoryUsage(values);
        } finally {
            r.close();
        }
    }
    private static final String[] HEADERS = new String[] {
        "MemTotal:",
        "MemFree:",
        "Buffers:",
        "Cached:"
    };
    private static final Suffix[] SUFFIXES = new Suffix[] {
        new Suffix("KB",1024),
        new Suffix("MB",1024*1024),
        new Suffix("GB",1024*1024*1024)
    };
    private static final Suffix NONE = new Suffix("",1);

    private static class Suffix {
        final String name;
        final long multiplier;

        private Suffix(String name, long multiplier) {
            this.name = name;
            this.multiplier = multiplier;
        }

        static Suffix find(String line) {
            for (Suffix s : SUFFIXES)
                if( line.substring(line.length()-s.name.length()).equalsIgnoreCase(s.name) )
                    return s;
            return NONE;
        }
    }
}

