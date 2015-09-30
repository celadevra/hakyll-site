---
title: Tracking issues with ikiwiki
created: 2015-05-20
...

## Design of the issue tracking system:

* /projects: A list of projects.
* /projects/${project name}: home page for each project, listing milestones and issues.
* /milestones/${milestone-xxx}: milestone page, listing issues related to the milestone and sub-milestones.
* /issues/${issue-yyy}: issue page, listing issue name, status, notes and related issues.

The above pages except /projects need to allow adding new issue and new milestones.

## Tag system for issue tracking:

Issue types: FILE/PAYMENTS/REVIEW/ERRAND

Deadline: YYYYMMDD

Issue status: FIXED/ONGOING/NEW/WONTFIX/WAITING

Belong to project: ${project name}

Belong to milestone ${milestone-xxx}

Corresponding smileys: (./)  (!)  {o}  {X}  (?)

[[!tag documentation issue-tracking]]
