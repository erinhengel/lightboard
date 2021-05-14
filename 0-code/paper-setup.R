knitr::opts_chunk$set(
  echo=FALSE,
  cache=FALSE,
  warning=FALSE
)

library(knitr)
library(tidyverse)
library(readxl)
library(kableExtra)
library(english)
library(testit)

# Determine whether HTML or PDF document.
doctype <- opts_knit$get("rmarkdown.pandoc.to")
if (is.null(doctype)) {
  doctype <- "html"
}

# Directory for cache.
if (doctype=="latex") {
  opts_chunk$set(cache.path = '.index_latex_cache/')
} else {
  opts_chunk$set(cache.path = '.index_html_cache/')
}

# Hook for figures
knit_hooks$set(plot = function(x, options) {
  if (doctype=="latex") {
    if (options$fig.pos=="h") {
      options$fig.pos <- "[ht]"
    }

    return(paste("\n\\begin{figure}", options$fig.pos, "\n",
                 "\\centering",
                 "\\includegraphics", ifelse(isTRUE(options$fig.manualwidth), paste("[width=", options$fig.width, "\\linewidth]", sep=""), ""), "{",
                 opts_knit$get("base.url"), paste(x, collapse = "."),
                 "}\n\n",
                 ifelse(!is.null(options$fig.note), paste("\\justify\\footnotesize\\textit{Note}. ", options$fig.note), ""),
                 "\n\\caption{", options$fig.cap, "}\n", "\\label{fig:", options$label, "}",
                 "\n\\end{figure}\n",
                 sep = '')
    )
  } else {
    return(paste('<div class="figure"><img src="',
                 opts_knit$get("base.url"), paste(x, collapse="."),'"\n',
                 'alt="', options$fig.cap, '">',
                 '<p align="left"><small><em>Note.</em> ', options$fig.note, '</small></p>',
                 '<p class="caption">(\\#fig:', options$label, ')', options$fig.cap, '</p></div>',
                 sep=''))
  }
})
knit_hooks$set(crop=hook_pdfcrop)

# Plot theme.
theme <- theme_set(theme_light())
theme <- theme_update(
  plot.title=element_text(colour="gray25", hjust=0.5, size=7),
  axis.text.x=element_text(colour="gray25", size=7),
  axis.text.y=element_text(colour="gray25", size=7),
  axis.title.x=element_text(colour="gray25", size=7),
  axis.title.y=element_text(colour="gray25", size=7),
  legend.position="bottom",
  legend.title = element_blank(),
  legend.text=element_text(colour="gray25", size=7),
  panel.border=element_blank(),
  legend.background=element_rect(colour = "transparent", fill=NA),
  legend.key.size=unit(0.3, "cm")
)
