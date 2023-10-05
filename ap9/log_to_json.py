import sys
import os
import json

log_files = [
    "bbs_damon-001.spec_adult-001-7days-bg.in_9.log",
    "bbs_damon-004.spec_adult-001-7days-bg.in_9.log",
    "bbs_damon-005.spec_adult-001-7days-bg.in_9.log",
    "bbs_towards-001.spec_adult-001-night-bg.in_9.log",
    "bbs_towards-002.spec_adult-001-night-bg.in_9.log",
    "bbs_towards-004.spec_adult-001-night-bg.in_9.log",
    "reversed_damon-001-rev.spec_adult-001-7days-bg.in_9.log",
    "reversed_damon-004-rev.spec_adult-001-7days-bg.in_9.log",
    "reversed_damon-005-rev.spec_adult-001-7days-bg.in_9.log",
#    "reversed_towards-001-rev.spec_adult-001-night-bg.in_9.log",
#    "reversed_towards-002-rev.spec_adult-001-night-bg.in_9.log",
#    "reversed_towards-004-rev.spec_adult-001-night-bg.in_9.log",
]


def main():
    if len(sys.argv) < 2:
        print("invalid argument".format(sys.argv[0]))
        print(" {} [path_to_log_dir]".format(sys.argv[0]))
        sys.exit(1)
    
    log_dir = sys.argv[1]
    for log_file in log_files:
        log_path = os.path.join(log_dir, log_file)
        process_log_file(log_path)

def process_log_file(log_file_name):
    print(log_file_name)
    results = dict()
    results["run_sum"] = 0
    results["run_num"] = 0
    results["enc_sum"] = 0
    results["enc_num"] = 0
    results["dec_sum"] = 0
    results["dec_num"] = 0
    with open(log_file_name) as f:
        for idx, line in enumerate(f):
            l = line.strip().split(",")
            if len(l) != 2 and len(l) != 3:
                raise Exception("invalid log format at line #{} {}".format(idx, line))

            if l[0] == "config-method":
                if l[1] == "bbs":
                    results[l[0]] = "block"
                elif l[1] == "reversed":
                    results[l[0]] = "reverse"
            elif l[0] in ["run", "enc", "dec"]:
                results["{}_sum".format(l[0])] += int(l[1])
                results["{}_num".format(l[0])] += 1
            else:
                results[l[0]] = l[1]
    #print(results)

    method = results["config-method"]
    schema_result = dict()
    schema_result["machine"] = "unknown"
    schema_result["benchmark"] = results["config-spec"]
    schema_result["framework"] = "HomFA"
    schema_result["method"] = method
    schema_result["total_time"] = results["run_sum"]
    schema_result["DFA_evaluation_time"] = results["run_sum"]
    schema_result["predicate_evaluation_time"] = 0
    schema_result["conversion_time"] = 0

    if method == "block":
        schema_result["block_size"] = int(results["config-queue_size"])
    elif method == "reverse":
        schema_result["bootstrapping_frequency"] = int(results["config-bootstrapping_freq"])
    schema_result = {log_file_name: schema_result}
    #print(schema_result)
    with open(log_file_name + ".json", 'w') as fj:
        fj.write(json.dumps(schema_result))

if __name__ == "__main__":
    main()
