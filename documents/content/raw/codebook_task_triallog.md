# Code book trial log

| Column name      | Description       | Units / Format  |
| ---------------- | ------------------------------ | ----- |
| studyId          | Study identity, as specified in experiment config file under `code` | N/A |
| taskVersionId    | Task verion identity, as specified in config file under `version` | N/A |
| sessionId        | Session identity, as specified by experimenter at beginning of the task| N/A |
| experimenterId   | Experimenter identity, specified by experimenter at beginning of the task | N/A |
| responseDevice   | Device with which participant performs the task | N/A |
| refreshRate      | Refresh rate of the computer screen| Hertz |
| rngSeed          | Seed of the random number generator|  N/A |
| subjectIx        | Subject index, specified by experimenter at beginning of the task |  N/A |
| groupIx          | Group index, specified by experimenter at beginning of the task |  N/A |
| sessionIx        | Session index, specified by experimenter at beginning of the task |  N/A |
| sessDate         | Session date| YYYY-MM-DD |
| sessTime         | Session time| HHMM, Greenwich Mean Time|
| blockId          | Block identity|  N/A |
| blockIx          | Block index|  N/A |
| trialIx          | Trial index|  N/A |
| fixIx            | Fixation index|  N/A |
| s1Ix             | Primary (go) stimulus index|  N/A |
| s2Ix             | Secondary (signal) stimulus index|  N/A |
| soaIx            | Stimulus onset asynchrony (i.e. signal-delay) index|  N/A |
| tSession         | Session time, i.e. time since task was launched| H:MM:SS|
| tBlock           | Block time, i.e. time since onset of current block| H:MM:SS.ms|
| trialOns         | Onset of current trial, relative to tSession| seconds |
| trialDur         | Duration of current trial| seconds |
| fixOns           | Actual onset of fixation stimulus| seconds |
| fixOnsDt         | Actual minus planned onset of fixation stimulus| seconds |
| fixDur           | Actual duration of fixation stimulus| seconds |
| fixDurDt         | Actual minus planned duration of fixation stimulus| seconds |
| s1Ons            | Actual onset of primary (go) stimulus| seconds |
| s1OnsDt          | Actual minus planned onset of primary (go) stimulus| seconds |
| s1Dur            | Actual duration of primary (go) stimulus| seconds |
| s1DurDt          | Actual minus planned duration of primary (go) stimulus| seconds |
| s2Ons            | Actual onset of secondary (signal) stimulus| seconds |
| s2OnsDt          | Actual minus planned onset of secondary (signal) stimulus| seconds |
| s2Dur            | Actual duration of secondary (signal) stimulus| seconds |
| s2DurDt          | Actual minus planned duration of secondary (signal) stimulus| seconds |
| waitedForTrigger | Whether or not the stimulus presentation software waited for a trigger| N/A  |
| keyCount_f       | Number of key strokes recorded for f-key |  N/A |
| keyTime1_f       | Time of first f-key stroke, relative to trial onset | seconds |
| keyTime2_f       | Time of second f-key stroke, relative to trial onset | seconds |
| keyCount_b       | Number of key strokes recorded for b-key | N/A |
| keyTime1_b       | Time of first b-key stroke, relative to trial onset | seconds |
| keyTime2_b       | Time of second b-key stroke, relative to trial onset | seconds |
| keyCount_e       | Number of key strokes recorded for e-key | N/A |
| keyTime1_e       | Time of first e-key stroke, relative to trial onset | seconds |
| keyTime2_e       | Time of second e-key stroke, relative to trial onset | seconds |
| keyCount_a       | Number of key strokes recorded for a-key | N/A |
| keyTime1_a       | Time of first a-key stroke, relative to trial onset | seconds |
| keyTime2_a       | Time of second a-key stroke, relative to trial onset | seconds |
| rt1_f            | Response time of first f-key stroke| seconds |
| rt2_f            | Response time of second f-key stroke| seconds |
| rt1_b            | Response time of first b-key stroke| seconds |
| rt2_b            | Response time of second b-key stroke| seconds |
| rt1_e            | Response time of first e-key stroke| seconds |
| rt2_e            | Response time of second e-key stroke| seconds |
| rt1_a            | Response time of first a-key stroke| seconds |
| rt2_a            | Response time of second a-key stroke| seconds |
| rt1_mean         | Mean response time across first bimanual key stroke | seconds |
| rt2_mean         | Mean response time across second bimanual key stroke | seconds |
| rt1_min          | Response time of fastest response of first bimanual key stroke | seconds |
| rt2_min          | Response time of fastest response of second bimanual key stroke | seconds |
| rt1_max          | Response time of slowest response of first bimanual key stroke | seconds |
| rt2_max          | Response time of slowest response of second bimanual key stroke | seconds |
| rtDiff1_f-b      | Response time difference between first f-key and b-key strokes| seconds |
| rtDiff1_e-a      | Response time difference between first e-key and a-key strokes| seconds |
| rtDiff2_f-b      | Response time difference between second f-key and b-key strokes| seconds |
| rtDiff2_e-a      | Response time difference between second e-key and a-key strokes| seconds |
| rtDiff1_mean     | Response time difference between responses of first bimanual key stroke | seconds |
| rtDiff2_mean     | Response time difference between responses of second bimanual key stroke | seconds |
| rpt1_f           | Raw processing time (amount of time available for viewing the stop signal) for first f-key stroke | seconds |
| rpt2_f           | Raw processing time for second f-key stroke | seconds |
| rpt1_b           | Raw processing time for first b-key stroke | seconds |
| rpt2_b           | Raw processing time for second b-key stroke | seconds |
| rpt1_e           | Raw processing time for first e-key stroke | seconds |
| rpt2_e           | Raw processing time for second e-key stroke | seconds |
| rpt1_a           | Raw processing time for first a-key stroke | seconds |
| rpt2_a           | Raw processing time for second a-key stroke | seconds |
| rpt1_mean        | Mean raw processing time across first bimanual key stroke | seconds |
| rpt2_mean        | Mean raw processing time across second bimanual key stroke | seconds |
| rpt1_min         | Raw processing time of fastest response of first bimanual key stroke | seconds |
| rpt2_min         | Raw processing time of fastest response of second bimanual key stroke | seconds |
| rpt1_max         | Raw processing time of slowest response of first bimanual key stroke | seconds |
| rpt2_max         | Raw processing time of slowest response of second bimanual key stroke | seconds |
| trialCorrect     | Whether or not the trial was performed correctly | N/A |
| trialType        | Trial type; can be no-signal (NS), stop-left (SL), stop-right (SR), stop-both (SB), or ignore (IG)| N/A |
| responseType     | Type of response made; | N/A |
| trialFeedback    | Feedback presented at the end of the trial| N/A |
