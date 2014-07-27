var Metalsmith = require('metalsmith'),
    markdown = require('metalsmith-markdown'),
    templates = require('metalsmith-templates'),
    branch = require('metalsmith-branch')
    collections = require('metalsmith-collections');

Metalsmith(__dirname)
    .source('./source')
    .use(branch('*.page')
        .use(markdown()))
    //.use(templates({
    //    engine: 'jade',
    //    directory: 'jade'
    //})
    //    )
    .destination('./build')
    .build()
