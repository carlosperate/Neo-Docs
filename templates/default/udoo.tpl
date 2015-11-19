<?php
    namespace Todaymade\Daux;
    class Template {

        private function get_navigation($tree, $path, $current_url, $base_page, $mode) {
            $nav = '<ul class="nav nav-list">';
            $nav .= $this->build_navigation($tree, $path, $current_url, $base_page, $mode);
            $nav .= '</ul>';
            return $nav;
        }

        private function build_navigation($tree, $path, $current_url, $base_page, $mode) {
            $nav = '';
            foreach ($tree->value as $node) {
            	$url = $node->uri;
                if ($node->type === \TodayMade\Daux\Directory_Entry::FILE_TYPE) {
                    if ($node->value === 'index') continue;
                    $nav .= '<li';
                    $link = ($path === '') ? $url : $path . '/' . $url;
                    if ($current_url === $link) $nav .= ' class="active"';
                    $nav .= '><a href="' . $base_page . $link . '">' . $node->title . '</a></li>';
                } else {
                    $nav .= '<li';
                    $link = ($path === '') ? $url : $path . '/' . $url;
                    if (strpos($current_url, $link) === 0) $nav .= ' class="open"';
                    $nav .= ">";
                    if ($mode === \TodayMade\Daux\Daux::STATIC_MODE) $link .= "/index.html";
                    if ($node->index_page) $nav .= '<a href="' . $base_page . $link . '" class="folder">' .
                        $node->title . '</a>';
                    else $nav .= '<a href="#" class="aj-nav folder">' . $node->title . '</a>';
                    $nav .= '<ul class="nav nav-list">';
                    $new_path = ($path === '') ? $url : $path . '/' . $url;
                    $nav .= $this->build_navigation($node, $new_path, $current_url, $base_page, $mode);
                    $nav .= '</ul></li>';
                }
            }
            return $nav;
        }

        private function get_breadcrumb_title($page, $base_page) {
            $title = '';
            $breadcrumb_trail = $page['breadcrumb_trail'];
            $separator = $this->get_separator($page['breadcrumb_separator']);
            foreach ($breadcrumb_trail as $key => $value) {
                $title .= '<a href="' . $base_page . $value . '">' . $key . '</a>' . $separator;
            }
            if ($page['filename'] === 'index' || $page['filename'] === '_index') {
                if ($page['title'] != '') $title = substr($title, 0, -1 * strlen($separator));
            } else $title .= '<a href="' . $base_page . $page['request'] . '">' . $page['title'] . '</a>';
            return $title;
        }

        private function get_separator($separator) {
            switch ($separator) {
                case 'Chevrons':
                    return ' <i class="glyphicon glyphicon-chevron-right"></i> ';
                default:
                    return $separator;
            }
        }

        public function get_content($page, $params) {
            $base_url = $params['base_url'];
            $base_page = $params['base_page'];
            $homepage = $page['homepage'];
            $project_title = utf8_encode($params['title']);
            $index = utf8_encode($base_page . $params['index']->value);
            $tree = $params['tree'];
            $entry_page = $page['entry_page'];
            ob_start();
?>
<!DOCTYPE html>
<!--[if lt IE 7]>       <html class="no-js ie6 oldie" lang="en"> <![endif]-->
<!--[if IE 7]>          <html class="no-js ie7 oldie" lang="en"> <![endif]-->
<!--[if IE 8]>          <html class="no-js ie8 oldie" lang="en"> <![endif]-->
<!--[if gt IE 8]><!-->  <html class="no-js" lang="en"> <!--<![endif]-->
<head>
    <title><?php echo $page['title']; ?></title>
    <meta name="description" content="<?php echo $page['tagline'];?>" />
    <meta name="author" content="<?php echo $page['author']; ?>">
    <meta charset="UTF-8">
    <link rel="icon" href="<?php echo $page['theme']['favicon']; ?>" type="image/x-icon">
    <!-- Mobile -->
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">




    <meta name="google-site-verification" content="GlKlGkbxuWQ3LNWx0akLYkqoWLrtF5b0ug9UpGadSuc" />

<meta name="google-site-verification" content="vL1Qo6JWKZBq6fzVJLJhbyqHya1TBhZd78OJDA-Qe1s" />












    <!-- Font -->
    <?php foreach ($page['theme']['fonts'] as $font) echo "<link href='$font' rel='stylesheet' type='text/css'>"; ?>

    <!-- CSS -->
    <?php foreach ($page['theme']['css'] as $css) echo "<link href='$css' rel='stylesheet' type='text/css'>"; ?>

</head>
<body>
    <?php if ($homepage) { ?>
    <!-- Homepage -->
        <div class="navbar navbar-fixed-top hidden-print">
            <div class="container">
				<a href="http://udoo.org" title="UDOO">
						<img src="udoo/img/logo_docs.png" alt="" />
				</a>
                <a class="brand navbar-brand pull-left" href="<?php echo $index; ?>">Docs</a>
                <p class="navbar-text pull-right">aaGenerated by <a href="http://daux.io">Daux.io</a></p>
            </div>
        </div>
        <?php if ($params['repo']) { ?>
            <a href="https://github.com/<?php echo $params['repo']; ?>" target="_blank" id="github-ribbon" class="hidden-print"><img src="https://s3.amazonaws.com/github/ribbons/forkme_right_darkblue_121621.png" alt="Fork me on GitHub"></a>
        <?php } ?>

        <div class="homepage-hero well container-fluid">
            <div class="container">
                <div class="row">
                    <div class="text-center col-sm-12">
                        <?php if ($page['tagline']) echo '<h2>' . $page['tagline'] . '</h2>'; ?>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-10 col-sm-offset-1">
                        <?php if ($params['image']) echo '<img class="homepage-image img-responsive" src="' . $params['image'] . '" alt="' . $project_title . '">'; ?>
                    </div>
                </div>
            </div>
        </div>

        <div class="hero-buttons container-fluid">
            <div class="container">
                <div class="row">
                    <div class="text-center col-sm-12">
                        <?php
                            if ($params['repo']) echo '<a href="https://github.com/' . $params['repo'] . '" class="btn btn-secondary btn-hero">View On GitHub</a>';
                            foreach ($entry_page as $key => $node) echo '<a href="' . $node . '" class="btn btn-primary btn-hero">' . $key . '</a>';
                        ?>
                    </div>
                </div>
            </div>
        </div>

        <div class="homepage-content container-fluid">
            <div class="container">
                <div class="row">
                    <div class="col-sm-10 col-sm-offset-1">
                        <?php echo $page['content'];?>
                    </div>
                </div>
            </div>
        </div>

        <div class="homepage-footer well container-fluid">
            <div class="container">
                <div class="row">
                    <div class="col-sm-5 col-sm-offset-1">
                        <?php if (!empty($params['links'])) { ?>
                            <ul class="footer-nav">
                                <?php foreach ($params['links'] as $name => $url) echo '<li><a href="' . $url . '" target="_blank">' . $name . '</a></li>'; ?>
                            </ul>
                        <?php } ?>
                    </div>
                    <div class="col-sm-5">
                        <div class="pull-right">
                            <?php
                                if (!empty($params['twitter'])) {
                                    foreach($params['twitter'] as $handle) {
                            ?>
                                        <div class="twitter">
                                            <iframe allowtransparency="true" frameborder="0" scrolling="no" style="width:162px; height:20px;" src="https://platform.twitter.com/widgets/follow_button.html?screen_name=<?php echo $handle;?>&amp;show_count=false"></iframe>
                                        </div>
                            <?php
                                    }
                                }
                            ?>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    <?php } else { ?>
        <!-- Docs -->
        <?php if ($params['repo']) { ?>
            <a href="https://github.com/<?php echo $params['repo']; ?>" target="_blank" id="github-ribbon" class="hidden-print"><img src="https://s3.amazonaws.com/github/ribbons/forkme_right_darkblue_121621.png" alt="Fork me on GitHub"></a>
        <?php } ?>
        <div class="container-fluid fluid-height wrapper">
            <div class="navbar navbar-fixed-top hidden-print">
                <div class="container-fluid">
                    <a class="brand navbar-brand pull-left" href="<?php echo $index;?>"><?php echo $project_title; ?></a>
                    <p class="navbar-text pull-right">Generated by <a href="http://daux.io">Daux.io</a></p>
                </div>
            </div>
            <div class="row columns content">
                <div class="left-column article-tree col-sm-3 hidden-print">
                    <!-- For Mobile -->
                    <div class="responsive-collapse">
                        <button type="button" class="btn btn-sidebar" id="menu-spinner-button">
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>
                    </div>
                    <div id="sub-nav-collapse" class="sub-nav-collapse">
                        <!-- Navigation -->
                        <?php
                            if ($page['language'] !== '') echo $this->get_navigation($tree->value[$page['language']], $page['language'], $params['request'], $base_page, $params['mode']);
                            else echo $this->get_navigation($tree, '', $params['request'], $base_page, $params['mode']);
                        ?>
                        <?php if (!empty($params['links']) || !empty($params['twitter'])) { ?>
                            <div class="well well-sidebar">

                                <!-- Links -->
                                <?php foreach ($params['links'] as $name => $url) echo '<a href="' . $url . '" target="_blank">' . $name . '</a><br>'; ?>
                                <?php if ($params['toggle_code']) echo '<a href="#" id="toggleCodeBlockBtn" onclick="toggleCodeBlocks();">Show Code Blocks Inline</a><br>'; ?>

                                <!-- Twitter -->
                                <?php foreach ($params['twitter'] as $handle) { ?>
                                    <div class="twitter">
                                        <hr/>
                                        <iframe allowtransparency="true" frameborder="0" scrolling="no" style="width:162px; height:20px;" src="https://platform.twitter.com/widgets/follow_button.html?screen_name=<?php echo $handle;?>&amp;show_count=false"></iframe>
                                    </div>
                                <?php } ?>
                            </div>
                        <?php } ?>
                    </div>
                </div>
                <div class="right-column <?php echo ($params['float']?'float-view':''); ?> content-area col-sm-9">
                    <div class="content-page">
                        <article>
                            <?php if ($params['date_modified']) { ?>
                                <div class="page-header sub-header clearfix">
                                    <h1><?php
                                            if ($page['breadcrumbs']) echo $this->get_breadcrumb_title($page, $base_page);
                                            else echo $page['title'];
                                        ?>
                                        <?php if ($page['file_editor']) echo '<a href="javascript:;" id="editThis" class="btn">Edit this page</a>'; ?>
                                    </h1>
                                    <span style="float: left; font-size: 10px; color: gray;">
                                        <?php echo date("l, F j, Y", $page['modified_time']);?>
                                    </span>
                                    <span style="float: right; font-size: 10px; color: gray;">
                                        <?php echo date("g:i A", $page['modified_time']);?>
                                    </span>
                                </div>
                            <?php } else { ?>
                                <div class="page-header">
                                    <h1><?php
                                            if ($page['breadcrumbs']) echo $this->get_breadcrumb_title($page, $base_page);
                                            else echo $page['title'];
                                        ?>
                                        <?php if ($page['file_editor']) echo '<a href="javascript:;" id="editThis" class="btn">Edit this page</a>'; ?>                                    </h1>
                                </div>
                            <?php } ?>

                            <?php echo $page['content']; ?>
                            <?php if ($page['file_editor']) { ?>
                                <div class="editor<?php if(!$params['date_modified']) echo ' paddingTop'; ?>">
                                    <h3>You are editing <?php echo $page['path']; ?>&nbsp;<a href="javascript:;" class="closeEditor btn btn-warning">Close</a></h3>
                                    <div class="navbar navbar-inverse navbar-default navbar-fixed-bottom" role="navigation">
                                        <div class="navbar-inner">
                                            <a href="javascript:;" class="save_editor btn btn-primary navbar-btn pull-right">Save file</a>
                                        </div>
                                    </div>
                                    <textarea id="markdown_editor"><?php echo $page['markdown'];?></textarea>
                                    <div class="clearfix"></div>
                                </div>
                            <?php } ?>
                        </article>
                    </div>
                </div>
            </div>
        </div>
    <?php } ?>

    <?php echo $page['google_analytics']; ?>
    <?php echo $page['piwik_analytics']; ?>


    <!-- jQuery -->
    <?php if ($page['theme']['require-jquery']) { ?>
        <script src="../js/jquery.min.js"></script>
        <script>
            if (typeof jQuery == 'undefined')
                document.write(unescape("%3Cscript src='<?php echo $base_url; ?>js/jquery-1.11.0.min.js' type='text/javascript'%3E%3C/script%3E"));
        </script>
    <?php
        }
        if ($page['theme']['bootstrap-js']) echo '<script src="' . $base_url . 'js/bootstrap.min.js' . '"></script>';
    ?>

    <!-- hightlight.js -->
    <script src="<?php echo $base_url; ?>js/highlight.min.js"></script>
    <script>hljs.initHighlightingOnLoad();</script>
    <script>toggleCodeBlocks();</script>
    <!-- JS -->
    <?php foreach ($page['theme']['js'] as $js) echo '<script src="' . $js . '"></script>'; ?>

    <!-- Front end file editor -->
    <?php if ($page['file_editor']) echo '<script src="'. $base_url. 'js/editor.js"></script>'; ?>
    <script src="<?php echo $base_url; ?>js/custom.js"></script>
    <!--[if lt IE 9]>
        <script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->
</body>
</html>

<?php
            $return = ob_get_contents();
            @ob_end_clean();
            return $return;
        }
    }
?>
