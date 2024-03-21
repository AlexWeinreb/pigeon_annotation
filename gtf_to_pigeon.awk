#!/bin/awk -f

function extract_attribute(field, attribute) {
    match(field, attribute "[ ]+\"[^\"]+\"", arr)
    if (length(arr) > 0) {
        gsub(attribute "[ ]+|\"", "", arr[0])
        return arr[0]
    }
    return ""
}


BEGIN {
    FS="\t"
	OFS="\t"
}

$3 == "gene" {
    gene_id_from_gene = extract_attribute($9, "gene_id")
    gene_name_from_gene = extract_attribute($9, "gene_name")
		
	print $1, $2, $3, $4, $5, $6, $7, $8, "gene_id \"" gene_id_from_gene "\"; gene_name \"" gene_name_from_gene "\";"
}

$3 == "transcript" {
    
	gene_id_from_tx = extract_attribute($9, "gene_id")
	transcript_id_from_tx = extract_attribute($9, "transcript_id")
	
	
	if(gene_id_from_tx != gene_id_from_gene){
	  print "Gene id doesn't match. Previous gene: " gene_id_from_gene " new one: " gene_id_from_tx 
	  exit 1
	}
	
	print $1, $2, $3, $4, $5, $6, $7, $8, "gene_id \"" gene_id_from_tx "\"; transcript_id \"" transcript_id_from_tx "\"; gene_name \"" gene_name_from_gene "\";"
}


$3 == "exon" {
    
	gene_id_from_ex = extract_attribute($9, "gene_id")
	transcript_id_from_ex = extract_attribute($9, "transcript_id")
	
	if(gene_id_from_ex != gene_id_from_tx){
	  print "Gene id doesn't match. Previous id: " gene_id_from_tx " new one: " gene_id_from_ex 
	  exit 1
	}
	if(transcript_id_from_ex != transcript_id_from_tx){
	  print "Transcript id doesn't match. Previous id: " transcript_id_from_tx " new one: " transcript_id_from_ex 
	  exit 1
	}
    
    print $1, $2, $3, $4, $5, $6, $7, $8, "gene_id \"" gene_id_from_tx "\"; transcript_id \"" transcript_id_from_ex "\"; gene_name \"" gene_name_from_gene "\";"
}

